### Roadmap Document: Events Tab UI and Functional Requirements

#### Overview

The Events tab in the Crete app is designed to replace the Voice tab, serving as a central hub for all time-sensitive activities, including voice channels, scheduled meetings, and governance-related events like proposal deadlines. This roadmap outlines the UI design, its functional requirements (UI-focused), and the strategic use of micro-interactions and animations to create an engaging, intuitive, and modern user experience.

---

#### UI Design

##### 1. **Event List (Timeline View)**

- **Layout**: A vertical timeline featuring events as **bubble-style cards** pinned according to their date and time.
  - **Bubble Cards**: Rounded cards with soft gradients and subtle shadows for depth, representing events like voice channels, meetings, or governance deadlines.
  - **Timeline**: A thin, dotted vertical line with a glowing dot marking the current time. Events are positioned relative to this line, with past events slightly faded.
- **Event Details on Each Bubble**:
  - **Title**: E.g., "General Voice Chat" or "Proposal Deadline: Funding Vote."
  - **Time**: Displays exact start time or a countdown (e.g., "In 2 hours").
  - **Type Indicator**: Icons for event types (e.g., microphone for voice, calendar for meetings, ballot for governance).
  - **Participant Count**: Small avatars or a number (e.g., "5 active") for voice events.
- **Visual Style**:
  - Bubbles use community-themed colors or a default Solana-inspired palette (purples, blues).
  - The timeline’s current time dot has a subtle glow effect.
- **Interactions**:
  - **Tap**: Opens the event detail screen with a smooth zoom-in animation.
  - **Swipe Right**: Pins the event to the top of the list.
  - **Swipe Left**: Snoozes reminders for the event.

##### 2. **Event Detail Screen**

- **Layout**:
  - **Header**: Displays event title, type icon, and time details.
  - **Main Content**: Varies by event type (detailed below).
  - **Action Buttons**: Context-specific buttons like "Join Now" for voice/meetings or "Vote Now" for governance.
- **Voice Event**:
  - Prominent "Join Now" button and a list of current participants with avatars.
  - Animated waveform background when the voice channel is active.
- **Meeting**:
  - Video feed (if applicable) with screen share options and a chat sidebar.
  - "RSVP" button with a confirmation animation (e.g., a star sparkle).
- **Governance Event**:
  - Links to proposal details with a countdown timer (e.g., a shrinking ring).
  - "Vote Now" button with a subtle shake effect if the deadline is near.
- **Micro-Interactions**:
  - Joining an event triggers a fade-in of controls with an optional welcoming sound.
  - RSVP or voting actions display a brief confirmation animation (e.g., checkmark or confetti).

##### 3. **Filters and Sorting**

- **Top Bar**: Tabs or dropdowns to filter events by type (All, Voice, Meetings, Governance).
- **Sorting Options**: Sort by time (upcoming first) or by community.
- **Visual Style**: Tabs feature a sleek, pill-shaped design with a subtle highlight on the selected filter.

##### 4. **Empty State**

- **Display**: If no events are scheduled, show a friendly illustration (e.g., a smiling calendar) with text like "No upcoming events. Check back later!"
- **Action**: Include a button to "Explore Communities" or "Create an Event" (if permitted).

---

#### Functional Requirements (UI Only)

##### 1. **Event List**

- **Display**: Must show at least 10 upcoming events, with infinite scrolling for additional events.
- **Real-Time Updates**: Event details (e.g., participant counts, time remaining) update in real-time.
- **Accessibility**: High contrast between text and background; minimum touch target size of 48dp for interactive elements.

##### 2. **Event Cards**

- **Content**: Must include title, time, type, and participant count (if applicable).
- **Customization**: Allow community hosts to set custom backgrounds or themes for their events.
- **Interactions**:
  - Tap to view event details.
  - Long press to access quick actions (e.g., set reminder, share event).

##### 3. **Event Detail Screen**

- **Voice Event**:
  - Prominent "Join Now" button, always accessible.
  - Participant list with avatars and mute/deafen controls.
- **Meeting**:
  - Video feed with toggles for camera and screen share.
  - RSVP button with clear visual feedback.
- **Governance Event**:
  - Clear display of proposal details and voting options.
  - Countdown timer that updates every second for accuracy.

##### 4. **Navigation**

- **Bottom Navigation**: Events tab must be easily accessible from the app’s bottom navigation bar.
- **Back Navigation**: Users can return to the event list via a back button or swipe gesture.

---

#### Micro-Interactions and Animations

##### 1. **Event List**

- **Bubble Load Animation**: Bubbles fade in with a slight bounce when the screen loads.
- **Timeline Glow**: The current time dot pulses subtly to draw attention.
- **Swipe Gestures**: Swiping an event triggers a smooth slide animation, revealing options like "Pin" or "Snooze."

##### 2. **Event Detail Screen**

- **Join Voice**: Tapping "Join Now" causes the button to ripple and expand, transitioning to voice controls.
- **RSVP Confirmation**: A star or checkmark animation appears briefly when RSVPing.
- **Vote Submission**: A subtle confetti burst or pulse effect occurs when a vote is cast.

##### 3. **General Interactions**

- **Screen Transitions**: Use slide or fade effects when moving between the event list and detail screens.
- **Loading States**: Display a spinning Solana logo or pulsing gradient circle during data fetches.
- **Hover Effects**: Event cards lift slightly or glow when tapped (or hovered, if applicable).

##### 4. **Strategic Use of Animations**

- **Purpose**: Enhance engagement without overwhelming the user.
- **Key Places**:
  - **Event Joining**: Ripple effect on "Join Now" to confirm action.
  - **Countdown Timers**: Smooth, continuous animation to convey urgency.
  - **Vote Tally Updates**: Numbers flip or slide when vote counts change.
- **Moderation**: Limit animations to key actions to maintain a clean, professional feel.

---

#### Accessibility Considerations

- **Color Contrast**: Ensure text readability against backgrounds (WCAG 2.1 AA compliant).
- **Touch Targets**: All interactive elements must be at least 48dp in size.
- **Screen Reader Support**: Include descriptions for icons and images for compatibility.

---

#### Conclusion

The Events tab will provide a visually appealing and functional hub for voice channels, meetings, and governance events in the Crete app. Its timeline-based design with bubble cards, paired with strategic micro-interactions like ripples and confetti, will create an engaging user experience. This roadmap balances aesthetics with usability, ensuring a modern, DAO-friendly interface that keeps users connected and informed.
