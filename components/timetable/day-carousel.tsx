'use client'

import { useEffect, useRef, useState } from 'react'
import { type DaySchedule } from '@/lib/timetable-data'
import { DayFlashcard } from './day-flashcard'
import { AddDayCard } from './add-day-card'

interface DayCarouselProps {
  schedule: DaySchedule[]
  todayIndex: number
  onDayChange: (index: number) => void
  onUpdateSchedule: (dayIndex: number, updatedSchedule: DaySchedule) => void
  onAddDay: () => void
}

export function DayCarousel({ schedule, todayIndex, onDayChange, onUpdateSchedule, onAddDay }: DayCarouselProps) {
  const scrollRef = useRef<HTMLDivElement>(null)
  const [focusedIndex, setFocusedIndex] = useState(todayIndex)

  useEffect(() => {
    // Scroll to today's card on mount
    if (scrollRef.current) {
      const cardWidth = scrollRef.current.scrollWidth / (schedule.length + 1) // +1 for add day card
      const scrollPosition = todayIndex * cardWidth - (scrollRef.current.clientWidth - cardWidth) / 2
      scrollRef.current.scrollTo({ left: scrollPosition, behavior: 'smooth' })
    }
  }, [todayIndex, schedule.length])

  const handleScroll = () => {
    if (!scrollRef.current) return
    
    const scrollLeft = scrollRef.current.scrollLeft
    const cardWidth = scrollRef.current.scrollWidth / (schedule.length + 1)
    const centerOffset = scrollRef.current.clientWidth / 2
    const newIndex = Math.round((scrollLeft + centerOffset - cardWidth / 2) / cardWidth)
    
    if (newIndex !== focusedIndex && newIndex >= 0 && newIndex <= schedule.length) {
      setFocusedIndex(newIndex)
      if (newIndex < schedule.length) {
        onDayChange(newIndex)
      }
    }
  }

  return (
    <div className="relative flex-1 flex items-center">
      {/* Gradient edges for visual depth */}
      <div className="absolute left-0 top-0 bottom-0 w-12 bg-gradient-to-r from-[#0B0C10] to-transparent z-10 pointer-events-none" />
      <div className="absolute right-0 top-0 bottom-0 w-12 bg-gradient-to-l from-[#0B0C10] to-transparent z-10 pointer-events-none" />

      {/* Carousel Container */}
      <div
        ref={scrollRef}
        onScroll={handleScroll}
        className="flex gap-4 overflow-x-auto snap-x-mandatory scrollbar-hide px-[7.5vw] py-4 w-full"
      >
        {schedule.map((day, index) => (
          <DayFlashcard
            key={day.day}
            schedule={day}
            isToday={index === todayIndex}
            isFocused={index === focusedIndex}
            onUpdateSchedule={(updated) => onUpdateSchedule(index, updated)}
          />
        ))}
        
        {/* Add Day Card at the end */}
        <AddDayCard onAdd={onAddDay} />
      </div>

      {/* Day Indicators */}
      <div className="absolute bottom-0 left-0 right-0 flex justify-center gap-2 pb-2">
        {schedule.map((day, index) => (
          <button
            key={day.day}
            onClick={() => {
              if (scrollRef.current) {
                const cardWidth = scrollRef.current.scrollWidth / (schedule.length + 1)
                const scrollPosition = index * cardWidth - (scrollRef.current.clientWidth - cardWidth) / 2
                scrollRef.current.scrollTo({ left: scrollPosition, behavior: 'smooth' })
              }
            }}
            className={`
              w-2 h-2 rounded-full transition-all duration-300
              ${index === focusedIndex 
                ? 'w-6 bg-[#66FCF1]' 
                : index === todayIndex 
                  ? 'bg-[#66FCF1]/50' 
                  : 'bg-[var(--muted-foreground)]/30'
              }
            `}
            aria-label={`Go to ${day.day}`}
          />
        ))}
        {/* Add day indicator */}
        <div className={`
          w-2 h-2 rounded-full transition-all duration-300
          ${focusedIndex === schedule.length ? 'w-6 bg-[#66FCF1]/60' : 'bg-[var(--muted-foreground)]/20'}
        `} />
      </div>
    </div>
  )
}
