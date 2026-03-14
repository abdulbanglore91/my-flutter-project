'use client'

import { Plus, CalendarPlus } from 'lucide-react'

interface AddDayCardProps {
  onAdd: () => void
}

export function AddDayCard({ onAdd }: AddDayCardProps) {
  return (
    <div className="snap-center flex-shrink-0 w-[85vw] max-w-[380px] scale-95 opacity-60 hover:scale-100 hover:opacity-80 transition-all duration-500">
      <button
        onClick={onAdd}
        className="
          w-full min-h-[65vh] flex flex-col items-center justify-center
          rounded-3xl border-2 border-dashed border-[var(--border)]
          bg-gradient-to-b from-[var(--glass)]/50 to-transparent
          hover:border-[#66FCF1]/40 hover:from-[#66FCF1]/5
          transition-all duration-300 group
        "
      >
        <div className="
          w-20 h-20 rounded-full 
          bg-[var(--muted)] border border-[var(--border)]
          flex items-center justify-center mb-6
          group-hover:bg-[#66FCF1]/10 group-hover:border-[#66FCF1]/40
          group-hover:scale-110
          transition-all duration-300
        ">
          <CalendarPlus className="w-10 h-10 text-[var(--muted-foreground)] group-hover:text-[#66FCF1] transition-colors" />
        </div>
        <h3 className="text-lg font-semibold text-[var(--muted-foreground)] group-hover:text-foreground mb-2 transition-colors">
          Add Day
        </h3>
        <p className="text-sm text-[var(--muted-foreground)]/70 text-center max-w-[200px]">
          Add a weekend or special schedule day
        </p>
      </button>
    </div>
  )
}
