'use client'

import { Home, Clock, User } from 'lucide-react'

export type NavItem = 'home' | 'free-slots' | 'profile'

interface FloatingNavProps {
  activeItem: NavItem
  onNavigate: (item: NavItem) => void
}

export function FloatingNav({ activeItem, onNavigate }: FloatingNavProps) {
  const handleClick = (item: NavItem) => {
    onNavigate(item)
  }

  const navItems: { id: NavItem; icon: typeof Home; label: string }[] = [
    { id: 'home', icon: Home, label: 'Home' },
    { id: 'free-slots', icon: Clock, label: 'Free Slots' },
    { id: 'profile', icon: User, label: 'Profiles' },
  ]

  return (
    <nav className="fixed bottom-6 left-1/2 -translate-x-1/2 z-50">
      <div className="glass-nav rounded-full px-2 py-2 flex items-center gap-1 card-shadow">
        {navItems.map(({ id, icon: Icon, label }) => (
          <button
            key={id}
            onClick={() => handleClick(id)}
            className={`
              relative flex items-center gap-2 px-5 py-3 rounded-full
              transition-all duration-300 ease-out
              ${activeItem === id 
                ? 'bg-[#66FCF1]/15 text-[#66FCF1]' 
                : 'text-[var(--muted-foreground)] hover:text-foreground hover:bg-[var(--muted)]'
              }
            `}
            aria-label={label}
          >
            <Icon className={`w-5 h-5 transition-transform duration-300 ${activeItem === id ? 'scale-110' : ''}`} />
            <span 
              className={`
                text-sm font-medium overflow-hidden transition-all duration-300
                ${activeItem === id ? 'w-auto opacity-100' : 'w-0 opacity-0'}
              `}
            >
              {label}
            </span>
            
            {/* Active indicator glow */}
            {activeItem === id && (
              <div className="absolute inset-0 rounded-full bg-[#66FCF1]/10 blur-xl -z-10" />
            )}
          </button>
        ))}
      </div>
    </nav>
  )
}
