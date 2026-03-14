'use client'

import { useState } from 'react'
import { Check, X, FileText } from 'lucide-react'

interface Program {
  id: string
  name: string
  subjects: string[]
}

interface ProgramSelectionModalProps {
  isOpen: boolean
  onClose: () => void
  onSelect: (programId: string) => void
  programs: Program[]
}

export function ProgramSelectionModal({ 
  isOpen, 
  onClose, 
  onSelect,
  programs 
}: ProgramSelectionModalProps) {
  const [selectedId, setSelectedId] = useState<string | null>(null)

  if (!isOpen) return null

  const handleSave = () => {
    if (selectedId) {
      onSelect(selectedId)
      onClose()
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        onClick={onClose}
      />
      
      {/* Modal */}
      <div 
        className="relative w-full max-w-md mx-4 mb-4 max-h-[85vh] flex flex-col rounded-3xl overflow-hidden"
        style={{
          background: 'rgba(26, 29, 36, 0.85)',
          backdropFilter: 'blur(24px)',
          WebkitBackdropFilter: 'blur(24px)',
          border: '1px solid rgba(255, 255, 255, 0.12)',
          boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255, 255, 255, 0.05)'
        }}
      >
        {/* Header */}
        <div className="px-6 pt-6 pb-4 flex-shrink-0">
          <div className="flex items-start justify-between mb-1">
            <div className="flex items-center gap-3">
              <div 
                className="w-10 h-10 rounded-xl flex items-center justify-center"
                style={{ background: 'rgba(102, 252, 241, 0.15)' }}
              >
                <FileText className="w-5 h-5 text-[#66FCF1]" />
              </div>
              <div>
                <h2 className="text-xl font-semibold text-foreground tracking-tight">
                  Select Your Program
                </h2>
                <p className="text-sm text-[var(--muted-foreground)]">
                  Only 1 program can be saved
                </p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="p-2 rounded-full hover:bg-[var(--muted)] transition-colors -mr-2 -mt-1"
              aria-label="Close modal"
            >
              <X className="w-5 h-5 text-[var(--muted-foreground)]" />
            </button>
          </div>
        </div>

        {/* Divider */}
        <div className="h-px bg-[var(--border)] mx-6" />

        {/* Program List */}
        <div className="flex-1 overflow-y-auto px-6 py-4 space-y-3 scrollbar-hide">
          {programs.map((program) => {
            const isSelected = selectedId === program.id
            
            return (
              <button
                key={program.id}
                onClick={() => setSelectedId(program.id)}
                className={`
                  w-full text-left p-4 rounded-2xl transition-all duration-300 relative
                  ${isSelected 
                    ? 'bg-[rgba(102,252,241,0.1)] border-[#66FCF1]/40' 
                    : 'bg-[var(--muted)] hover:bg-[rgba(255,255,255,0.08)] border-transparent'
                  }
                  border
                `}
                style={{
                  boxShadow: isSelected 
                    ? '0 0 20px rgba(102, 252, 241, 0.15), inset 0 1px 0 rgba(255,255,255,0.05)' 
                    : 'inset 0 1px 0 rgba(255,255,255,0.03)'
                }}
              >
                <div className="flex items-start gap-3">
                  {/* Radio indicator */}
                  <div 
                    className={`
                      w-5 h-5 rounded-full flex-shrink-0 mt-0.5
                      flex items-center justify-center transition-all duration-300
                      ${isSelected 
                        ? 'bg-[#66FCF1] shadow-[0_0_12px_rgba(102,252,241,0.5)]' 
                        : 'border-2 border-[var(--muted-foreground)]'
                      }
                    `}
                  >
                    {isSelected && (
                      <Check className="w-3 h-3 text-[#0B0C10]" strokeWidth={3} />
                    )}
                  </div>

                  <div className="flex-1 min-w-0">
                    {/* Program name */}
                    <h3 className={`
                      text-base font-medium truncate transition-colors duration-300
                      ${isSelected ? 'text-[#66FCF1]' : 'text-foreground'}
                    `}>
                      {program.name}
                    </h3>
                    
                    {/* Subjects preview */}
                    <p className="text-sm text-[var(--muted-foreground)] mt-1 leading-relaxed">
                      {program.subjects.slice(0, 4).map((subject, i) => (
                        <span key={i}>
                          {i > 0 && <span className="mx-1.5 opacity-50">•</span>}
                          {subject}
                        </span>
                      ))}
                    </p>
                  </div>
                </div>
              </button>
            )
          })}
        </div>

        {/* Footer with Save Button */}
        <div className="px-6 pb-6 pt-4 flex-shrink-0">
          <button
            onClick={handleSave}
            disabled={!selectedId}
            className={`
              w-full py-4 rounded-2xl font-semibold text-base
              transition-all duration-300 relative overflow-hidden
              ${selectedId
                ? 'bg-[#66FCF1] text-[#0B0C10] hover:bg-[#7FFFD4] active:scale-[0.98]'
                : 'bg-[var(--muted)] text-[var(--muted-foreground)] cursor-not-allowed'
              }
            `}
            style={{
              boxShadow: selectedId 
                ? '0 0 30px rgba(102, 252, 241, 0.4), 0 4px 15px rgba(102, 252, 241, 0.3)' 
                : 'none'
            }}
          >
            {/* Glow effect overlay */}
            {selectedId && (
              <div 
                className="absolute inset-0 opacity-30"
                style={{
                  background: 'linear-gradient(180deg, rgba(255,255,255,0.3) 0%, transparent 50%)'
                }}
              />
            )}
            <span className="relative z-10">Save Timetable</span>
          </button>
        </div>
      </div>
    </div>
  )
}

// Sample programs for demo
export const samplePrograms: Program[] = [
  {
    id: 'bsit-5th-sem3',
    name: 'BSIT (5th Intake) Sem3',
    subjects: ['Network Security', 'Web Engineering', 'Civics', 'Database Systems']
  },
  {
    id: 'bsit-5th-sem4',
    name: 'BSIT (5th Intake) Sem4',
    subjects: ['Software Engineering', 'AI Fundamentals', 'Mobile Dev', 'Cloud Computing']
  },
  {
    id: 'bscs-6th-sem5',
    name: 'BSCS (6th Intake) Sem5',
    subjects: ['Machine Learning', 'Compiler Design', 'Distributed Systems', 'HCI']
  },
  {
    id: 'bsse-4th-sem2',
    name: 'BSSE (4th Intake) Sem2',
    subjects: ['Data Structures', 'OOP Concepts', 'Technical Writing', 'Calculus II']
  },
  {
    id: 'bsai-1st-sem1',
    name: 'BSAI (1st Intake) Sem1',
    subjects: ['Programming Fundamentals', 'Linear Algebra', 'Intro to AI', 'Statistics']
  }
]
