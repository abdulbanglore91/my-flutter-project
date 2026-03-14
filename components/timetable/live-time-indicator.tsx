'use client'

import { useEffect, useState } from 'react'
import { getCurrentTimeInMinutes, getTimeInMinutes, type ClassSession } from '@/lib/timetable-data'

interface LiveTimeIndicatorProps {
  classes: ClassSession[]
  isToday: boolean
}

export function LiveTimeIndicator({ classes, isToday }: LiveTimeIndicatorProps) {
  const [position, setPosition] = useState<number | null>(null)
  const [isVisible, setIsVisible] = useState(false)

  useEffect(() => {
    if (!isToday || classes.length === 0) {
      setIsVisible(false)
      return
    }

    const calculatePosition = () => {
      const currentMinutes = getCurrentTimeInMinutes()
      const firstClassStart = getTimeInMinutes(classes[0].startTime)
      const lastClassEnd = getTimeInMinutes(classes[classes.length - 1].endTime)

      // Only show indicator during class hours
      if (currentMinutes < firstClassStart - 30 || currentMinutes > lastClassEnd + 30) {
        setIsVisible(false)
        return
      }

      setIsVisible(true)

      // Calculate percentage position
      const totalDuration = lastClassEnd - firstClassStart
      const elapsed = currentMinutes - firstClassStart
      const percentage = Math.max(0, Math.min(100, (elapsed / totalDuration) * 100))
      
      setPosition(percentage)
    }

    calculatePosition()
    const interval = setInterval(calculatePosition, 30000) // Update every 30 seconds
    return () => clearInterval(interval)
  }, [classes, isToday])

  if (!isVisible || position === null) return null

  return (
    <div 
      className="absolute left-[7px] w-[2px] h-full pointer-events-none"
      style={{ top: 0 }}
    >
      {/* Glowing time indicator line */}
      <div 
        className="absolute left-0 w-full bg-[#66FCF1] timeline-glow transition-all duration-1000 ease-out"
        style={{ 
          height: `${position}%`,
          background: 'linear-gradient(to bottom, transparent, #66FCF1)'
        }}
      />
      
      {/* Pulsing current time dot */}
      <div 
        className="absolute left-1/2 -translate-x-1/2 w-3 h-3 rounded-full bg-[#66FCF1] pulse-dot transition-all duration-1000 ease-out"
        style={{ top: `${position}%` }}
      >
        {/* Inner glow */}
        <div className="absolute inset-0 rounded-full bg-[#66FCF1] animate-ping opacity-75" />
      </div>
    </div>
  )
}
