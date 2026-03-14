'use client'

import { useState, useEffect } from 'react'
import { ContextualHeader } from '@/components/timetable/contextual-header'
import { DayCarousel } from '@/components/timetable/day-carousel'
import { FloatingNav, type NavItem } from '@/components/timetable/floating-nav'
import { FreeSlotsScreen } from '@/components/timetable/free-slots-screen'
import { ProgramSelectionModal, samplePrograms } from '@/components/timetable/program-selection-modal'
import { weekSchedule, type DaySchedule } from '@/lib/timetable-data'
import { Upload } from 'lucide-react'

export default function TimetablePage() {
  const [schedule, setSchedule] = useState<DaySchedule[]>(weekSchedule)
  const [todayIndex, setTodayIndex] = useState(0)
  const [currentDayIndex, setCurrentDayIndex] = useState(0)
  const [activeNav, setActiveNav] = useState<NavItem>('home')
  const [showProgramModal, setShowProgramModal] = useState(false)

  const handleProgramSelect = (programId: string) => {
    // In a real app, this would load the selected program's timetable
    console.log('Selected program:', programId)
  }

  useEffect(() => {
    // Get today's day of week (0 = Sunday, 1 = Monday, etc.)
    const today = new Date().getDay()
    // Convert to our schedule index (Monday = 0, Sunday = 6)
    const scheduleIndex = today === 0 ? 6 : today - 1
    setTodayIndex(scheduleIndex)
    setCurrentDayIndex(scheduleIndex)
  }, [])

  const handleDayChange = (index: number) => {
    setCurrentDayIndex(index)
  }

  const handleUpdateSchedule = (dayIndex: number, updatedSchedule: DaySchedule) => {
    setSchedule(prev => {
      const newSchedule = [...prev]
      newSchedule[dayIndex] = updatedSchedule
      return newSchedule
    })
  }

  const handleAddDay = () => {
    // Generate next available day
    const existingDays = schedule.map(s => s.day.toLowerCase())
    const allDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
    const nextDay = allDays.find(d => !existingDays.includes(d))
    
    if (nextDay) {
      const dayNames: Record<string, { full: string, short: string }> = {
        monday: { full: 'Monday', short: 'Mon' },
        tuesday: { full: 'Tuesday', short: 'Tue' },
        wednesday: { full: 'Wednesday', short: 'Wed' },
        thursday: { full: 'Thursday', short: 'Thu' },
        friday: { full: 'Friday', short: 'Fri' },
        saturday: { full: 'Saturday', short: 'Sat' },
        sunday: { full: 'Sunday', short: 'Sun' }
      }
      
      const newDay: DaySchedule = {
        day: dayNames[nextDay].full,
        shortDay: dayNames[nextDay].short,
        date: 'Custom',
        classes: []
      }
      
      setSchedule(prev => [...prev, newDay])
    }
  }

  const todaySchedule = schedule[todayIndex]
  const currentDay = schedule[currentDayIndex]

  return (
    <main className="min-h-screen bg-[#0B0C10] flex flex-col overflow-hidden">
      {/* Ambient background gradients */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden">
        <div className="absolute -top-1/4 -right-1/4 w-[600px] h-[600px] bg-[#66FCF1]/5 rounded-full blur-[120px]" />
        <div className="absolute -bottom-1/4 -left-1/4 w-[500px] h-[500px] bg-[#7B2CBF]/5 rounded-full blur-[100px]" />
      </div>

      {/* Content */}
      <div className="relative z-10 flex flex-col min-h-screen">
        {activeNav === 'home' && (
          <>
            {/* Contextual Header */}
            <ContextualHeader 
              todayClasses={todaySchedule?.classes || []} 
              currentDay={currentDay?.day || 'Monday'}
            />

            {/* Day Carousel */}
            <DayCarousel 
              schedule={schedule}
              todayIndex={todayIndex}
              onDayChange={handleDayChange}
              onUpdateSchedule={handleUpdateSchedule}
              onAddDay={handleAddDay}
            />

            {/* Bottom spacing for nav */}
            <div className="h-24" />
          </>
        )}

        {activeNav === 'free-slots' && (
          <FreeSlotsScreen 
            schedule={schedule}
            todayIndex={todayIndex}
          />
        )}

        {activeNav === 'profile' && (
          <div className="flex-1 flex flex-col items-center justify-center px-6 gap-6">
            <div className="text-center">
              <div className="w-20 h-20 rounded-full bg-[var(--muted)] mx-auto mb-4 flex items-center justify-center">
                <span className="text-3xl text-[var(--muted-foreground)]">P</span>
              </div>
              <h2 className="text-xl font-semibold text-foreground mb-2">Profile</h2>
              <p className="text-[var(--muted-foreground)] mb-6">Manage your timetable</p>
              
              {/* Upload PDF Button */}
              <button
                onClick={() => setShowProgramModal(true)}
                className="inline-flex items-center gap-2 px-6 py-3 rounded-2xl bg-[#66FCF1] text-[#0B0C10] font-semibold transition-all hover:bg-[#7FFFD4] active:scale-95"
                style={{
                  boxShadow: '0 0 20px rgba(102, 252, 241, 0.3)'
                }}
              >
                <Upload className="w-5 h-5" />
                Upload Timetable PDF
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Floating Navigation */}
      <FloatingNav activeItem={activeNav} onNavigate={setActiveNav} />

      {/* Program Selection Modal */}
      <ProgramSelectionModal
        isOpen={showProgramModal}
        onClose={() => setShowProgramModal(false)}
        onSelect={handleProgramSelect}
        programs={samplePrograms}
      />
    </main>
  )
}
