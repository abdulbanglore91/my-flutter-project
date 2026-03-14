'use client'

import { type DaySchedule, type ClassSession } from '@/lib/timetable-data'
import { ClassNode } from './class-node'
import { AddClassButton } from './add-class-button'
import { Calendar, Coffee } from 'lucide-react'
import { useState } from 'react'

interface DayFlashcardProps {
  schedule: DaySchedule
  isToday: boolean
  isFocused: boolean
  onUpdateSchedule?: (updatedSchedule: DaySchedule) => void
}

export function DayFlashcard({ schedule, isToday, isFocused, onUpdateSchedule }: DayFlashcardProps) {
  const [isAddingClass, setIsAddingClass] = useState(false)
  const [newClass, setNewClass] = useState<Partial<ClassSession>>({
    subject: '',
    teacher: '',
    room: '',
    type: 'lecture',
    startTime: '09:00',
    endTime: '10:30'
  })

  const handleAddClass = () => {
    setIsAddingClass(true)
  }

  const handleSaveNewClass = () => {
    if (!newClass.subject) return
    
    const classSession: ClassSession = {
      id: `${schedule.day.toLowerCase()}-${Date.now()}`,
      subject: newClass.subject || '',
      teacher: newClass.teacher || '',
      room: newClass.room || '',
      type: newClass.type as ClassSession['type'],
      startTime: newClass.startTime || '09:00',
      endTime: newClass.endTime || '10:30'
    }

    const updatedSchedule = {
      ...schedule,
      classes: [...schedule.classes, classSession].sort((a, b) => 
        a.startTime.localeCompare(b.startTime)
      )
    }

    onUpdateSchedule?.(updatedSchedule)
    setIsAddingClass(false)
    setNewClass({
      subject: '',
      teacher: '',
      room: '',
      type: 'lecture',
      startTime: '09:00',
      endTime: '10:30'
    })
  }

  const handleCancelNewClass = () => {
    setIsAddingClass(false)
    setNewClass({
      subject: '',
      teacher: '',
      room: '',
      type: 'lecture',
      startTime: '09:00',
      endTime: '10:30'
    })
  }

  const handleUpdateClass = (updatedSession: ClassSession) => {
    const updatedSchedule = {
      ...schedule,
      classes: schedule.classes.map(c => 
        c.id === updatedSession.id ? updatedSession : c
      ).sort((a, b) => a.startTime.localeCompare(b.startTime))
    }
    onUpdateSchedule?.(updatedSchedule)
  }

  const handleDeleteClass = (id: string) => {
    const updatedSchedule = {
      ...schedule,
      classes: schedule.classes.filter(c => c.id !== id)
    }
    onUpdateSchedule?.(updatedSchedule)
  }

  return (
    <div
      className={`
        snap-center flex-shrink-0 w-[85vw] max-w-[380px]
        transition-all duration-500 ease-out
        ${isFocused ? 'scale-100 opacity-100' : 'scale-95 opacity-60'}
      `}
    >
      <div className="glass-card rounded-3xl p-5 card-shadow min-h-[65vh] flex flex-col">
        {/* Day Header */}
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-2xl font-bold text-foreground tracking-tight">
              {schedule.day}
            </h2>
            <p className="text-sm text-[var(--muted-foreground)] mt-0.5 flex items-center gap-2">
              <Calendar className="w-3.5 h-3.5" />
              {schedule.date}
            </p>
          </div>
          {isToday && (
            <span className="px-3 py-1.5 rounded-full text-xs font-semibold uppercase tracking-wider bg-[#66FCF1]/15 text-[#66FCF1] border border-[#66FCF1]/30">
              Today
            </span>
          )}
        </div>

        {/* Classes Timeline or Empty State */}
        <div className="flex-1 overflow-y-auto scrollbar-hide">
          {schedule.classes.length > 0 || isAddingClass ? (
            <div className="relative">
              {schedule.classes.map((session) => (
                <ClassNode 
                  key={session.id} 
                  session={session} 
                  isToday={isToday}
                  onUpdate={handleUpdateClass}
                  onDelete={handleDeleteClass}
                />
              ))}
              
              {/* New Class Form */}
              {isAddingClass && (
                <NewClassForm 
                  newClass={newClass}
                  setNewClass={setNewClass}
                  onSave={handleSaveNewClass}
                  onCancel={handleCancelNewClass}
                />
              )}

              {/* Add Class Button */}
              {!isAddingClass && (
                <AddClassButton onClick={handleAddClass} />
              )}
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center h-full text-center py-12">
              <div className="w-16 h-16 rounded-full bg-[var(--muted)] flex items-center justify-center mb-4">
                <Coffee className="w-8 h-8 text-[#66FCF1]" />
              </div>
              <h3 className="text-lg font-semibold text-foreground mb-2">
                Day Off
              </h3>
              <p className="text-sm text-[var(--muted-foreground)] max-w-[200px] mb-6">
                No classes scheduled. Take some time to rest or catch up on assignments.
              </p>
              <AddClassButton onClick={handleAddClass} />
            </div>
          )}
        </div>

        {/* Class Count Footer */}
        {schedule.classes.length > 0 && (
          <div className="mt-4 pt-4 border-t border-[var(--border)]">
            <p className="text-xs text-[var(--muted-foreground)] text-center">
              {schedule.classes.length} class{schedule.classes.length !== 1 ? 'es' : ''} scheduled
            </p>
          </div>
        )}
      </div>
    </div>
  )
}

// New Class Form Component
import { MapPin, Check, X } from 'lucide-react'

interface NewClassFormProps {
  newClass: Partial<ClassSession>
  setNewClass: React.Dispatch<React.SetStateAction<Partial<ClassSession>>>
  onSave: () => void
  onCancel: () => void
}

const CLASS_TYPES = ['lecture', 'practical', 'combined'] as const

function NewClassForm({ newClass, setNewClass, onSave, onCancel }: NewClassFormProps) {
  const getTypeStyles = (type: string, isSelected = false) => {
    const base = isSelected ? '' : 'opacity-40'
    switch (type) {
      case 'practical':
        return `bg-[#7B2CBF]/20 text-[#C77DFF] border-[#7B2CBF]/30 ${base}`
      case 'combined':
        return `bg-[#66FCF1]/15 text-[#66FCF1] border-[#66FCF1]/30 ${base}`
      default:
        return `bg-[var(--muted)] text-[var(--muted-foreground)] border-[var(--border)] ${base}`
    }
  }

  return (
    <div className="relative pl-8 pb-6">
      {/* Timeline connector */}
      <div className="absolute left-[7px] top-2 bottom-0 w-[2px] bg-gradient-to-b from-[#66FCF1]/40 to-transparent" />
      
      {/* Timeline dot - pulsing for new class */}
      <div className="absolute left-0 top-2 w-4 h-4 rounded-full border-2 bg-[#66FCF1] border-[#66FCF1] pulse-dot" />

      {/* New Class Card */}
      <div className="glass-card rounded-2xl p-4 card-shadow border-[#66FCF1]/60 scale-[1.02]">
        <div className="space-y-4">
          {/* Time Inputs */}
          <div className="flex items-center gap-2">
            <input
              type="time"
              value={newClass.startTime}
              onChange={e => setNewClass(d => ({ ...d, startTime: e.target.value }))}
              className="bg-transparent text-sm font-medium text-[#66FCF1] border-b border-[#66FCF1]/30 focus:border-[#66FCF1] outline-none px-1 py-0.5 w-24"
            />
            <span className="text-[var(--muted-foreground)]">—</span>
            <input
              type="time"
              value={newClass.endTime}
              onChange={e => setNewClass(d => ({ ...d, endTime: e.target.value }))}
              className="bg-transparent text-sm font-medium text-[#66FCF1] border-b border-[#66FCF1]/30 focus:border-[#66FCF1] outline-none px-1 py-0.5 w-24"
            />
          </div>

          {/* Subject Input */}
          <input
            type="text"
            value={newClass.subject}
            onChange={e => setNewClass(d => ({ ...d, subject: e.target.value }))}
            placeholder="Subject Name"
            autoFocus
            className="w-full bg-transparent text-lg font-semibold text-foreground border-b border-[var(--border)] focus:border-[#66FCF1]/50 outline-none pb-2 placeholder:text-[var(--muted-foreground)]"
          />

          {/* Teacher & Room Row */}
          <div className="flex items-center gap-4">
            <input
              type="text"
              value={newClass.teacher}
              onChange={e => setNewClass(d => ({ ...d, teacher: e.target.value }))}
              placeholder="Teacher Name"
              className="flex-1 bg-transparent text-sm text-[var(--muted-foreground)] border-b border-[var(--border)] focus:border-[#66FCF1]/50 outline-none pb-1 placeholder:text-[var(--muted-foreground)]/50"
            />
            <div className="flex items-center gap-1.5">
              <MapPin className="w-3.5 h-3.5 text-[#66FCF1]/70" />
              <input
                type="text"
                value={newClass.room}
                onChange={e => setNewClass(d => ({ ...d, room: e.target.value }))}
                placeholder="Room"
                className="w-20 bg-transparent text-sm text-[var(--muted-foreground)] border-b border-[var(--border)] focus:border-[#66FCF1]/50 outline-none pb-1 placeholder:text-[var(--muted-foreground)]/50"
              />
            </div>
          </div>

          {/* Type Selector */}
          <div className="flex items-center gap-2">
            {CLASS_TYPES.map(type => (
              <button
                key={type}
                onClick={() => setNewClass(d => ({ ...d, type }))}
                className={`
                  text-xs px-3 py-1.5 rounded-full border font-medium uppercase tracking-wider
                  transition-all duration-200
                  ${getTypeStyles(type, newClass.type === type)}
                  ${newClass.type === type ? 'scale-105' : 'hover:opacity-70'}
                `}
              >
                {type}
              </button>
            ))}
          </div>

          {/* Action Buttons */}
          <div className="flex items-center justify-end gap-2 pt-2 border-t border-[var(--border)]">
            <button
              onClick={onCancel}
              className="flex items-center gap-1 text-[var(--muted-foreground)] hover:text-foreground text-sm font-medium transition-colors px-3 py-1.5"
            >
              <X className="w-4 h-4" />
              Cancel
            </button>
            <button
              onClick={onSave}
              disabled={!newClass.subject}
              className="flex items-center gap-1 bg-[#66FCF1] text-[#0B0C10] px-4 py-1.5 rounded-full text-sm font-semibold hover:bg-[#66FCF1]/90 transition-all cyan-glow disabled:opacity-50 disabled:cursor-not-allowed disabled:shadow-none"
            >
              <Check className="w-4 h-4" />
              Add Class
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
