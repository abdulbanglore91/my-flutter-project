'use client'

import { useState, useEffect, useRef } from 'react'
import { MapPin, Clock } from 'lucide-react'
import { 
  type DaySchedule, 
  type FreeSlot,
  calculateFreeSlots, 
  formatTime, 
  getCurrentTimeInMinutes,
  getSlotStatus,
  getTimeInMinutes
} from '@/lib/timetable-data'

interface FreeSlotsScreenProps {
  schedule: DaySchedule[]
  todayIndex: number
}

export function FreeSlotsScreen({ schedule, todayIndex }: FreeSlotsScreenProps) {
  const [mounted, setMounted] = useState(false)
  const [currentMinutes, setCurrentMinutes] = useState(0)
  const [selectedDayIndex, setSelectedDayIndex] = useState(todayIndex)
  const liveSlotRef = useRef<HTMLDivElement>(null)

  const freeSlots = calculateFreeSlots(schedule, selectedDayIndex)
  const isToday = selectedDayIndex === todayIndex

  useEffect(() => {
    setMounted(true)
    setSelectedDayIndex(todayIndex)
    
    const updateTime = () => {
      setCurrentMinutes(getCurrentTimeInMinutes())
    }
    
    updateTime()
    const interval = setInterval(updateTime, 30000) // Update every 30 seconds
    return () => clearInterval(interval)
  }, [todayIndex])

  // Scroll to live slot after mount
  useEffect(() => {
    if (mounted && liveSlotRef.current && isToday) {
      setTimeout(() => {
        liveSlotRef.current?.scrollIntoView({ behavior: 'smooth', block: 'center' })
      }, 300)
    }
  }, [mounted, isToday])

  const days = schedule.map((s, i) => ({ 
    name: s.shortDay, 
    index: i,
    isToday: i === todayIndex 
  }))

  if (!mounted) {
    return (
      <div className="flex-1 px-6 pt-6 pb-28">
        <div className="h-8 w-48 bg-[var(--muted)] rounded-lg animate-pulse mb-6" />
        <div className="space-y-4">
          {[1, 2, 3].map(i => (
            <div key={i} className="h-32 bg-[var(--muted)] rounded-2xl animate-pulse" />
          ))}
        </div>
      </div>
    )
  }

  return (
    <div className="flex-1 flex flex-col">
      {/* Header */}
      <header className="px-6 pt-14 pb-4">
        <div className="flex items-center gap-2 mb-2">
          <Clock className="w-5 h-5 text-[#66FCF1]" />
          <span className="text-sm font-medium text-[#66FCF1]">Free Rooms</span>
        </div>
        <h1 className="text-2xl font-semibold text-foreground tracking-tight">
          Find Empty Rooms
        </h1>
        <p className="text-sm text-[var(--muted-foreground)] mt-1">
          Rooms available throughout the day
        </p>
      </header>

      {/* Day Selector Pills */}
      <div className="px-6 pb-4">
        <div className="flex gap-2 overflow-x-auto scrollbar-hide pb-2">
          {days.map(({ name, index, isToday: dayIsToday }) => (
            <button
              key={index}
              onClick={() => setSelectedDayIndex(index)}
              className={`
                px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap
                transition-all duration-200
                ${selectedDayIndex === index 
                  ? 'bg-[#66FCF1] text-[#0B0C10]' 
                  : dayIsToday
                    ? 'bg-[#66FCF1]/20 text-[#66FCF1] border border-[#66FCF1]/30'
                    : 'bg-[var(--muted)] text-[var(--muted-foreground)] hover:bg-[var(--muted)]/80'
                }
              `}
            >
              {name}
              {dayIsToday && selectedDayIndex !== index && (
                <span className="ml-1 w-1.5 h-1.5 bg-[#66FCF1] rounded-full inline-block" />
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Timeline */}
      <div className="flex-1 overflow-y-auto px-6 pb-28 scrollbar-hide">
        {freeSlots.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 text-center">
            <div className="w-16 h-16 rounded-full bg-[var(--muted)] flex items-center justify-center mb-4">
              <MapPin className="w-8 h-8 text-[var(--muted-foreground)]" />
            </div>
            <p className="text-[var(--muted-foreground)]">No free rooms available</p>
            <p className="text-sm text-[var(--muted-foreground)]/60 mt-1">All rooms are occupied today</p>
          </div>
        ) : (
          <div className="relative">
            {/* Timeline line */}
            <div className="absolute left-3 top-4 bottom-4 w-px bg-gradient-to-b from-[#66FCF1]/40 via-[var(--border)] to-transparent" />
            
            {/* Time slots */}
            <div className="space-y-4">
              {freeSlots.map((slot, index) => {
                const status = isToday ? getSlotStatus(slot.startTime, slot.endTime, currentMinutes) : 'upcoming'
                const isLive = status === 'live'
                const isPassed = status === 'passed'
                
                return (
                  <div
                    key={`${slot.startTime}-${slot.endTime}`}
                    ref={isLive ? liveSlotRef : null}
                    className={`
                      relative pl-10 transition-opacity duration-300
                      ${isPassed ? 'opacity-40' : 'opacity-100'}
                    `}
                  >
                    {/* Timeline dot */}
                    <div 
                      className={`
                        absolute left-0 top-4 w-6 h-6 rounded-full flex items-center justify-center
                        transition-all duration-300
                        ${isLive 
                          ? 'bg-[#66FCF1] pulse-dot' 
                          : isPassed 
                            ? 'bg-[var(--muted)]' 
                            : 'bg-[var(--glass)] border border-[var(--glass-border)]'
                        }
                      `}
                    >
                      <div 
                        className={`
                          w-2 h-2 rounded-full
                          ${isLive ? 'bg-[#0B0C10]' : isPassed ? 'bg-[var(--muted-foreground)]' : 'bg-[#66FCF1]/60'}
                        `}
                      />
                    </div>
                    
                    {/* Time Card */}
                    <div 
                      className={`
                        glass-card rounded-2xl p-4 transition-all duration-300
                        ${isLive 
                          ? 'border-[#66FCF1]/50 cyan-glow' 
                          : 'border-[var(--glass-border)]'
                        }
                      `}
                    >
                      {/* Time Header */}
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-2">
                          <span className={`text-base font-semibold ${isLive ? 'text-[#66FCF1]' : 'text-foreground'}`}>
                            {formatTime(slot.startTime)}
                          </span>
                          <span className="text-[var(--muted-foreground)]">to</span>
                          <span className={`text-base font-semibold ${isLive ? 'text-[#66FCF1]' : 'text-foreground'}`}>
                            {formatTime(slot.endTime)}
                          </span>
                        </div>
                        
                        {isLive && (
                          <div className="flex items-center gap-1.5 px-2 py-1 rounded-full bg-[#66FCF1]/15 border border-[#66FCF1]/30">
                            <div className="w-1.5 h-1.5 rounded-full bg-[#66FCF1] animate-pulse" />
                            <span className="text-xs font-medium text-[#66FCF1]">Live</span>
                          </div>
                        )}
                      </div>
                      
                      {/* Duration */}
                      <p className="text-xs text-[var(--muted-foreground)] mb-3">
                        {getDuration(slot.startTime, slot.endTime)}
                      </p>
                      
                      {/* Room Pills */}
                      <div className="flex flex-wrap gap-2">
                        {slot.rooms.map(room => (
                          <div
                            key={room}
                            className={`
                              flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-medium
                              transition-all duration-200
                              ${isLive 
                                ? 'bg-[#66FCF1]/15 text-[#66FCF1] border border-[#66FCF1]/30' 
                                : 'bg-[var(--muted)] text-[var(--muted-foreground)] border border-[var(--border)]'
                              }
                            `}
                          >
                            <MapPin className="w-3.5 h-3.5" />
                            {room}
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

function getDuration(startTime: string, endTime: string): string {
  const startMin = getTimeInMinutes(startTime)
  const endMin = getTimeInMinutes(endTime)
  const diff = endMin - startMin
  
  const hours = Math.floor(diff / 60)
  const mins = diff % 60
  
  if (hours === 0) return `${mins} min`
  if (mins === 0) return `${hours} hr`
  return `${hours} hr ${mins} min`
}
