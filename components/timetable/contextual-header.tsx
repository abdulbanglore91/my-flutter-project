'use client'

import { useEffect, useState } from 'react'
import { getGreeting, getRemainingClasses, getCurrentTimeInMinutes, type ClassSession } from '@/lib/timetable-data'

interface ContextualHeaderProps {
  todayClasses: ClassSession[]
  currentDay: string
}

export function ContextualHeader({ todayClasses, currentDay }: ContextualHeaderProps) {
  const [mounted, setMounted] = useState(false)
  const [greeting, setGreeting] = useState('')
  const [currentTime, setCurrentTime] = useState('')
  const [remainingClasses, setRemainingClasses] = useState(0)

  useEffect(() => {
    setMounted(true)
    
    const updateTime = () => {
      const now = new Date()
      setCurrentTime(now.toLocaleTimeString('en-US', { 
        hour: 'numeric', 
        minute: '2-digit',
        hour12: true 
      }))
      setGreeting(getGreeting())
      setRemainingClasses(getRemainingClasses(todayClasses, getCurrentTimeInMinutes()))
    }

    updateTime()
    const interval = setInterval(updateTime, 1000)
    return () => clearInterval(interval)
  }, [todayClasses])

  const getMessage = () => {
    if (todayClasses.length === 0) {
      return "No classes today. Enjoy your day off!"
    }
    if (remainingClasses === 0) {
      return "All classes done for today!"
    }
    return `You have ${remainingClasses} class${remainingClasses !== 1 ? 'es' : ''} left today.`
  }

  // Show placeholder during SSR to prevent hydration mismatch
  if (!mounted) {
    return (
      <header className="px-6 pt-14 pb-6">
        <div className="flex items-center gap-2 mb-3">
          <div className="w-2 h-2 rounded-full bg-[#66FCF1] pulse-dot" />
          <span className="text-sm font-medium text-[#66FCF1] tracking-wide opacity-0">00:00 AM</span>
          <span className="text-sm text-[var(--muted-foreground)]">• {currentDay}</span>
        </div>
        <h1 className="text-3xl font-semibold text-foreground tracking-tight mb-1 opacity-0">
          Loading...
        </h1>
        <p className="text-base text-[var(--muted-foreground)] leading-relaxed opacity-0">
          Loading...
        </p>
      </header>
    )
  }

  return (
    <header className="px-6 pt-14 pb-6">
      {/* Time Display */}
      <div className="flex items-center gap-2 mb-3">
        <div className="w-2 h-2 rounded-full bg-[#66FCF1] pulse-dot" />
        <span className="text-sm font-medium text-[#66FCF1] tracking-wide">{currentTime}</span>
        <span className="text-sm text-[var(--muted-foreground)]">• {currentDay}</span>
      </div>

      {/* Greeting */}
      <h1 className="text-3xl font-semibold text-foreground tracking-tight mb-1">
        {greeting}
      </h1>

      {/* Context Message */}
      <p className="text-base text-[var(--muted-foreground)] leading-relaxed">
        {getMessage()}
      </p>
    </header>
  )
}
