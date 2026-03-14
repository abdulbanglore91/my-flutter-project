'use client'

import { Plus } from 'lucide-react'

interface AddClassButtonProps {
  onClick: () => void
}

export function AddClassButton({ onClick }: AddClassButtonProps) {
  return (
    <button
      onClick={onClick}
      className="
        relative w-full mt-4 py-4 px-6
        flex items-center justify-center gap-2
        rounded-2xl border-2 border-dashed border-[#66FCF1]/30
        bg-gradient-to-r from-[#66FCF1]/5 to-[#7B2CBF]/5
        hover:border-[#66FCF1]/50 hover:from-[#66FCF1]/10 hover:to-[#7B2CBF]/10
        transition-all duration-300 group
      "
    >
      <div className="
        w-8 h-8 rounded-full 
        bg-[#66FCF1]/20 border border-[#66FCF1]/40
        flex items-center justify-center
        group-hover:bg-[#66FCF1]/30 group-hover:border-[#66FCF1]/60
        group-hover:scale-110 group-hover:cyan-glow
        transition-all duration-300
      ">
        <Plus className="w-4 h-4 text-[#66FCF1]" />
      </div>
      <span className="text-sm font-medium text-[#66FCF1]/80 group-hover:text-[#66FCF1] transition-colors">
        Add Makeup Class
      </span>
    </button>
  )
}
