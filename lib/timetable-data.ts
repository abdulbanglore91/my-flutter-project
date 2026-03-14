export interface ClassSession {
  id: string
  subject: string
  teacher: string
  room: string
  startTime: string
  endTime: string
  type?: 'practical' | 'combined' | 'lecture'
}

export interface DaySchedule {
  day: string
  shortDay: string
  date: string
  classes: ClassSession[]
}

export const weekSchedule: DaySchedule[] = [
  {
    day: 'Monday',
    shortDay: 'Mon',
    date: 'Mar 17',
    classes: [
      {
        id: 'mon-1',
        subject: 'Data Structures & Algorithms',
        teacher: 'Dr. Sarah Chen',
        room: 'LH-201',
        startTime: '09:00',
        endTime: '10:30',
        type: 'lecture'
      },
      {
        id: 'mon-2',
        subject: 'Machine Learning',
        teacher: 'Prof. James Mitchell',
        room: 'CS-Lab 3',
        startTime: '11:00',
        endTime: '12:30',
        type: 'practical'
      },
      {
        id: 'mon-3',
        subject: 'Database Systems',
        teacher: 'Dr. Emily Watson',
        room: 'LH-105',
        startTime: '14:00',
        endTime: '15:30',
        type: 'combined'
      }
    ]
  },
  {
    day: 'Tuesday',
    shortDay: 'Tue',
    date: 'Mar 18',
    classes: [
      {
        id: 'tue-1',
        subject: 'Computer Networks',
        teacher: 'Dr. Michael Brown',
        room: 'LH-302',
        startTime: '08:30',
        endTime: '10:00',
        type: 'lecture'
      },
      {
        id: 'tue-2',
        subject: 'Software Engineering',
        teacher: 'Prof. Lisa Park',
        room: 'LH-201',
        startTime: '10:30',
        endTime: '12:00',
        type: 'lecture'
      },
      {
        id: 'tue-3',
        subject: 'Web Development Lab',
        teacher: 'Mr. David Kim',
        room: 'CS-Lab 1',
        startTime: '14:00',
        endTime: '16:00',
        type: 'practical'
      }
    ]
  },
  {
    day: 'Wednesday',
    shortDay: 'Wed',
    date: 'Mar 19',
    classes: [
      {
        id: 'wed-1',
        subject: 'Operating Systems',
        teacher: 'Dr. Robert Taylor',
        room: 'LH-401',
        startTime: '09:00',
        endTime: '10:30',
        type: 'lecture'
      },
      {
        id: 'wed-2',
        subject: 'Artificial Intelligence',
        teacher: 'Prof. Anna Lee',
        room: 'LH-201',
        startTime: '11:00',
        endTime: '12:30',
        type: 'combined'
      },
      {
        id: 'wed-3',
        subject: 'Cloud Computing',
        teacher: 'Dr. Chris Anderson',
        room: 'CS-Lab 2',
        startTime: '15:00',
        endTime: '17:00',
        type: 'practical'
      }
    ]
  },
  {
    day: 'Thursday',
    shortDay: 'Thu',
    date: 'Mar 20',
    classes: [
      {
        id: 'thu-1',
        subject: 'Data Structures & Algorithms',
        teacher: 'Dr. Sarah Chen',
        room: 'CS-Lab 3',
        startTime: '09:00',
        endTime: '11:00',
        type: 'practical'
      },
      {
        id: 'thu-2',
        subject: 'Computer Networks',
        teacher: 'Dr. Michael Brown',
        room: 'LH-302',
        startTime: '11:30',
        endTime: '13:00',
        type: 'lecture'
      },
      {
        id: 'thu-3',
        subject: 'Cybersecurity Fundamentals',
        teacher: 'Prof. Rachel Green',
        room: 'LH-105',
        startTime: '14:30',
        endTime: '16:00',
        type: 'lecture'
      }
    ]
  },
  {
    day: 'Friday',
    shortDay: 'Fri',
    date: 'Mar 21',
    classes: [
      {
        id: 'fri-1',
        subject: 'Machine Learning',
        teacher: 'Prof. James Mitchell',
        room: 'LH-201',
        startTime: '10:00',
        endTime: '11:30',
        type: 'lecture'
      },
      {
        id: 'fri-2',
        subject: 'Database Systems Lab',
        teacher: 'Dr. Emily Watson',
        room: 'CS-Lab 1',
        startTime: '13:00',
        endTime: '15:00',
        type: 'practical'
      }
    ]
  },
  {
    day: 'Saturday',
    shortDay: 'Sat',
    date: 'Mar 22',
    classes: [
      {
        id: 'sat-1',
        subject: 'Project Workshop',
        teacher: 'Prof. Lisa Park',
        room: 'CS-Lab 2',
        startTime: '10:00',
        endTime: '13:00',
        type: 'practical'
      }
    ]
  },
  {
    day: 'Sunday',
    shortDay: 'Sun',
    date: 'Mar 23',
    classes: []
  }
]

export function getTimeInMinutes(time: string): number {
  const [hours, minutes] = time.split(':').map(Number)
  return hours * 60 + minutes
}

export function getCurrentTimeInMinutes(): number {
  const now = new Date()
  return now.getHours() * 60 + now.getMinutes()
}

export function getClassStatus(startTime: string, endTime: string, currentMinutes: number): 'passed' | 'active' | 'upcoming' {
  const start = getTimeInMinutes(startTime)
  const end = getTimeInMinutes(endTime)
  
  if (currentMinutes > end) return 'passed'
  if (currentMinutes >= start && currentMinutes <= end) return 'active'
  return 'upcoming'
}

export function formatTime(time: string): string {
  const [hours, minutes] = time.split(':').map(Number)
  const period = hours >= 12 ? 'PM' : 'AM'
  const displayHours = hours % 12 || 12
  return `${displayHours}:${minutes.toString().padStart(2, '0')} ${period}`
}

export function getGreeting(): string {
  const hour = new Date().getHours()
  if (hour < 12) return 'Good Morning'
  if (hour < 17) return 'Good Afternoon'
  return 'Good Evening'
}

export function getRemainingClasses(classes: ClassSession[], currentMinutes: number): number {
  return classes.filter(c => getTimeInMinutes(c.endTime) > currentMinutes).length
}

// All available rooms in the campus
export const allRooms = [
  'LH-201', 'LH-105', 'LH-302', 'LH-401',
  'CS-Lab 1', 'CS-Lab 2', 'CS-Lab 3',
  'MAB CR-162', 'MAB CR-224', 'NAB CR-101', 'NAB CR-224'
]

export interface FreeSlot {
  startTime: string
  endTime: string
  rooms: string[]
}

// Get all classes across the entire week for a specific time slot
export function getOccupiedRooms(allSchedules: DaySchedule[], dayIndex: number, startMin: number, endMin: number): string[] {
  const daySchedule = allSchedules[dayIndex]
  if (!daySchedule) return []
  
  const occupiedRooms: string[] = []
  
  for (const session of daySchedule.classes) {
    const sessionStart = getTimeInMinutes(session.startTime)
    const sessionEnd = getTimeInMinutes(session.endTime)
    
    // Check if the time ranges overlap
    if (startMin < sessionEnd && endMin > sessionStart) {
      occupiedRooms.push(session.room)
    }
  }
  
  return occupiedRooms
}

// Calculate free slots for a given day
export function calculateFreeSlots(allSchedules: DaySchedule[], dayIndex: number): FreeSlot[] {
  const daySchedule = allSchedules[dayIndex]
  if (!daySchedule) return []
  
  // Collect all time boundaries from classes
  const boundaries = new Set<number>()
  boundaries.add(8 * 60)  // 8:00 AM start
  boundaries.add(18 * 60) // 6:00 PM end
  
  for (const session of daySchedule.classes) {
    boundaries.add(getTimeInMinutes(session.startTime))
    boundaries.add(getTimeInMinutes(session.endTime))
  }
  
  // Sort boundaries
  const sortedBoundaries = Array.from(boundaries).sort((a, b) => a - b)
  
  // Create time intervals and find free rooms for each
  const freeSlots: FreeSlot[] = []
  
  for (let i = 0; i < sortedBoundaries.length - 1; i++) {
    const startMin = sortedBoundaries[i]
    const endMin = sortedBoundaries[i + 1]
    
    // Skip very short intervals (less than 10 minutes)
    if (endMin - startMin < 10) continue
    
    const occupiedRooms = getOccupiedRooms(allSchedules, dayIndex, startMin, endMin)
    const freeRooms = allRooms.filter(room => !occupiedRooms.includes(room))
    
    if (freeRooms.length > 0) {
      freeSlots.push({
        startTime: minutesToTime(startMin),
        endTime: minutesToTime(endMin),
        rooms: freeRooms
      })
    }
  }
  
  return freeSlots
}

export function minutesToTime(minutes: number): string {
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60
  return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`
}

export function getSlotStatus(startTime: string, endTime: string, currentMinutes: number): 'passed' | 'live' | 'upcoming' {
  const start = getTimeInMinutes(startTime)
  const end = getTimeInMinutes(endTime)
  
  if (currentMinutes >= end) return 'passed'
  if (currentMinutes >= start && currentMinutes < end) return 'live'
  return 'upcoming'
}
