'use client'

import { MapPin, Check, Trash2, X } from 'lucide-react'
import { type ClassSession, formatTime, getClassStatus, getCurrentTimeInMinutes } from '@/lib/timetable-data'
import { useEffect, useState } from 'react'

interface ClassNodeProps {
  session: ClassSession
  isToday: boolean
  onUpdate?: (session: ClassSession) => void
  onDelete?: (id: string) => void
}

const CLASS_TYPES = ['lecture', 'practical', 'combined'] as const

export function ClassNode({ session, isToday, onUpdate, onDelete }: ClassNodeProps) {
  const [status, setStatus] = useState<'passed' | 'active' | 'upcoming'>('upcoming')
  const [isEditing, setIsEditing] = useState(false)
  const [editData, setEditData] = useState({
    subject: session.subject,
    teacher: session.teacher,
    room: session.room,
    type: session.type || 'lecture',
    startTime: session.startTime,
    endTime: session.endTime
  })

  useEffect(() => {
    if (!isToday) {
      setStatus('upcoming')
      return
    }

    const updateStatus = () => {
      setStatus(getClassStatus(session.startTime, session.endTime, getCurrentTimeInMinutes()))
    }

    updateStatus()
    const interval = setInterval(updateStatus, 30000)
    return () => clearInterval(interval)
  }, [session.startTime, session.endTime, isToday])

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

  const getStatusClass = () => {
    if (!isToday) return ''
    switch (status) {
      case 'passed':
        return 'class-passed'
      case 'active':
        return 'active-class'
      default:
        return 'class-future'
    }
  }

  const handleSave = () => {
    onUpdate?.({
      ...session,
      ...editData,
      type: editData.type as ClassSession['type']
    })
    setIsEditing(false)
  }

  const handleCancel = () => {
    setEditData({
      subject: session.subject,
      teacher: session.teacher,
      room: session.room,
      type: session.type || 'lecture',
      startTime: session.startTime,
      endTime: session.endTime
    })
    setIsEditing(false)
  }

  return (
    <div
      className={`
        relative pl-8 pb-6 last:pb-0
        ${getStatusClass()}
        transition-all duration-500 ease-out
      `}
    >
      {/* Timeline connector */}
      <div className="absolute left-[7px] top-2 bottom-0 w-[2px] bg-gradient-to-b from-[#66FCF1]/40 to-transparent last:hidden" />
      
      {/* Timeline dot */}
      <div 
        className={`
          absolute left-0 top-2 w-4 h-4 rounded-full border-2
          ${status === 'active' && isToday
            ? 'bg-[#66FCF1] border-[#66FCF1] pulse-dot' 
            : status === 'passed' && isToday
              ? 'bg-[var(--muted)] border-[var(--border)]'
              : 'bg-[#1a1d24] border-[#66FCF1]/50'
          }
          transition-all duration-300
        `}
      />

      {/* Class Card */}
      <div 
        onClick={() => !isEditing && setIsEditing(true)}
        className={`
          glass-card rounded-2xl p-4 card-shadow cursor-pointer
          ${status === 'active' && isToday ? 'border-[#66FCF1]/40' : ''}
          ${isEditing ? 'border-[#66FCF1]/60 scale-[1.02]' : ''}
          transition-all duration-300 hover:scale-[1.02] hover:border-[#66FCF1]/30
        `}
      >
        {isEditing ? (
          /* Edit Mode */
          <div className="space-y-4" onClick={e => e.stopPropagation()}>
            {/* Time Inputs */}
            <div className="flex items-center gap-2">
              <input
                type="time"
                value={editData.startTime}
                onChange={e => setEditData(d => ({ ...d, startTime: e.target.value }))}
                className="bg-transparent text-sm font-medium text-[#66FCF1] border-b border-[#66FCF1]/30 focus:border-[#66FCF1] outline-none px-1 py-0.5 w-24"
              />
              <span className="text-[var(--muted-foreground)]">—</span>
              <input
                type="time"
                value={editData.endTime}
                onChange={e => setEditData(d => ({ ...d, endTime: e.target.value }))}
                className="bg-transparent text-sm font-medium text-[#66FCF1] border-b border-[#66FCF1]/30 focus:border-[#66FCF1] outline-none px-1 py-0.5 w-24"
              />
            </div>

            {/* Subject Input */}
            <input
              type="text"
              value={editData.subject}
              onChange={e => setEditData(d => ({ ...d, subject: e.target.value }))}
              placeholder="Subject Name"
              className="w-full bg-transparent text-lg font-semibold text-foreground border-b border-[var(--border)] focus:border-[#66FCF1]/50 outline-none pb-2 placeholder:text-[var(--muted-foreground)]"
            />

            {/* Teacher & Room Row */}
            <div className="flex items-center gap-4">
              <input
                type="text"
                value={editData.teacher}
                onChange={e => setEditData(d => ({ ...d, teacher: e.target.value }))}
                placeholder="Teacher Name"
                className="flex-1 bg-transparent text-sm text-[var(--muted-foreground)] border-b border-[var(--border)] focus:border-[#66FCF1]/50 outline-none pb-1 placeholder:text-[var(--muted-foreground)]/50"
              />
              <div className="flex items-center gap-1.5">
                <MapPin className="w-3.5 h-3.5 text-[#66FCF1]/70" />
                <input
                  type="text"
                  value={editData.room}
                  onChange={e => setEditData(d => ({ ...d, room: e.target.value }))}
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
                  onClick={() => setEditData(d => ({ ...d, type }))}
                  className={`
                    text-xs px-3 py-1.5 rounded-full border font-medium uppercase tracking-wider
                    transition-all duration-200
                    ${getTypeStyles(type, editData.type === type)}
                    ${editData.type === type ? 'scale-105' : 'hover:opacity-70'}
                  `}
                >
                  {type}
                </button>
              ))}
            </div>

            {/* Action Buttons */}
            <div className="flex items-center justify-between pt-2 border-t border-[var(--border)]">
              <button
                onClick={() => onDelete?.(session.id)}
                className="flex items-center gap-1.5 text-[#FF6B6B] hover:text-[#FF6B6B]/80 text-sm font-medium transition-colors"
              >
                <Trash2 className="w-4 h-4" />
                Delete
              </button>
              <div className="flex items-center gap-2">
                <button
                  onClick={handleCancel}
                  className="flex items-center gap-1 text-[var(--muted-foreground)] hover:text-foreground text-sm font-medium transition-colors px-3 py-1.5"
                >
                  <X className="w-4 h-4" />
                  Cancel
                </button>
                <button
                  onClick={handleSave}
                  className="flex items-center gap-1 bg-[#66FCF1] text-[#0B0C10] px-4 py-1.5 rounded-full text-sm font-semibold hover:bg-[#66FCF1]/90 transition-all cyan-glow"
                >
                  <Check className="w-4 h-4" />
                  Save
                </button>
              </div>
            </div>
          </div>
        ) : (
          /* View Mode */
          <>
            {/* Time Row */}
            <div className="flex items-center justify-between mb-3">
              <span className="text-sm font-medium text-[#66FCF1]">
                {formatTime(session.startTime)} — {formatTime(session.endTime)}
              </span>
              {session.type && (
                <span className={`text-xs px-2.5 py-1 rounded-full border ${getTypeStyles(session.type, true)} font-medium uppercase tracking-wider`}>
                  {session.type}
                </span>
              )}
            </div>

            {/* Subject */}
            <h3 className="text-lg font-semibold text-foreground mb-2 leading-tight">
              {session.subject}
            </h3>

            {/* Details Row */}
            <div className="flex items-center justify-between text-sm text-[var(--muted-foreground)]">
              <span>{session.teacher}</span>
              <span className="flex items-center gap-1.5">
                <MapPin className="w-3.5 h-3.5 text-[#66FCF1]/70" />
                {session.room}
              </span>
            </div>

            {/* Active indicator glow */}
            {status === 'active' && isToday && (
              <div className="absolute inset-0 rounded-2xl bg-gradient-to-r from-[#66FCF1]/5 to-[#7B2CBF]/5 pointer-events-none" />
            )}
          </>
        )}
      </div>
    </div>
  )
}
