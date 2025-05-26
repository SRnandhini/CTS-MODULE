// ===== 1. JavaScript Basics & Setup =====
// main.js
console.log("Welcome to the Community Portal");

window.addEventListener('load', () => {
  alert("Community Portal is fully loaded!");
});

// ===== 2. Syntax, Data Types, and Operators =====
const eventName = "Community Bake Sale";
const eventDate = "2023-12-15";
let availableSeats = 50;

function updateEventInfo() {
  console.log(`Event: ${eventName} on ${eventDate}. Seats available: ${availableSeats}`);
}

function registerForEvent() {
  if (availableSeats > 0) {
    availableSeats--;
    updateEventInfo();
  } else {
    console.log("Sorry, no seats available!");
  }
}

// ===== 3. Conditionals, Loops, and Error Handling =====
const events = [
  { id: 1, name: "Bake Sale", date: "2023-12-15", seats: 50, category: "food" },
  { id: 2, name: "Music Festival", date: "2023-11-20", seats: 0, category: "music" },
  { id: 3, name: "Art Workshop", date: "2023-12-01", seats: 15, category: "art" }
];

function displayValidEvents() {
  const today = new Date().toISOString().split('T')[0];
  
  events.forEach(event => {
    try {
      if (new Date(event.date) >= new Date(today) && event.seats > 0) {
        console.log(`VALID: ${event.name} on ${event.date}`);
      }
    } catch (error) {
      console.error(`Error processing event ${event.id}:`, error);
    }
  });
}

// ===== 4. Functions, Scope, Closures, Higher-Order Functions =====
function createEventManager() {
  let totalRegistrations = 0;
  
  return {
    addEvent: (name, date, seats, category) => {
      const newEvent = { id: events.length + 1, name, date, seats, category };
      events.push(newEvent);
      return newEvent;
    },
    
    registerUser: (eventId) => {
      const event = events.find(e => e.id === eventId);
      if (event && event.seats > 0) {
        event.seats--;
        totalRegistrations++;
        return true;
      }
      return false;
    },
    
    filterEvents: (callback) => events.filter(callback),
    
    getTotalRegistrations: () => totalRegistrations
  };
}

const eventManager = createEventManager();

// ===== 5. Objects and Prototypes =====
class Event {
  constructor(id, name, date, seats, category) {
    this.id = id;
    this.name = name;
    this.date = date;
    this.seats = seats;
    this.category = category;
  }
  
  checkAvailability() {
    return this.seats > 0;
  }
  
  static fromObject(obj) {
    return new Event(obj.id, obj.name, obj.date, obj.seats, obj.category);
  }
}

// Convert existing events to Event class instances
const eventInstances = events.map(event => Event.fromObject(event));

// ===== 6. Arrays and Methods =====
// Add new event
eventManager.addEvent("Music Night", "2023-12-10", 30, "music");

// Filter music events
const musicEvents = eventManager.filterEvents(event => event.category === "music");

// Format event display cards
const eventCards = events.map(event => ({
  title: `${event.name} (${event.category})`,
  date: new Date(event.date).toLocaleDateString(),
  seats: `${event.seats} seats left`
}));

// ===== 7. DOM Manipulation =====
function renderEvents(eventsList) {
  const container = document.querySelector('#events-container');
  container.innerHTML = '';
  
  eventsList.forEach(event => {
    const card = document.createElement('div');
    card.className = 'event-card';
    card.innerHTML = `
      <h3>${event.name}</h3>
      <p>Date: ${event.date}</p>
      <p>Seats: ${event.seats}</p>
      <button class="register-btn" data-id="${event.id}">Register</button>
    `;
    container.appendChild(card);
  });
}

// ===== 8. Event Handling =====
document.addEventListener('DOMContentLoaded', () => {
  // Initial render
  renderEvents(events);
  
  // Register button click
  document.addEventListener('click', (e) => {
    if (e.target.classList.contains('register-btn')) {
      const eventId = parseInt(e.target.dataset.id);
      if (eventManager.registerUser(eventId)) {
        renderEvents(events);
        alert("Registration successful!");
      } else {
        alert("Registration failed. No seats available.");
      }
    }
  });
  
  // Category filter
  document.querySelector('#category-filter').addEventListener('change', (e) => {
    const category = e.target.value;
    const filtered = category === 'all' 
      ? events 
      : eventManager.filterEvents(event => event.category === category);
    renderEvents(filtered);
  });
  
  // Quick search
  document.querySelector('#search-input').addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      const searchTerm = e.target.value.toLowerCase();
      const filtered = eventManager.filterEvents(event => 
        event.name.toLowerCase().includes(searchTerm)
      );
      renderEvents(filtered);
    }
  });
});

// ===== 9. Async JS, Promises, Async/Await =====
async function fetchEvents() {
  try {
    // Show loading spinner
    document.querySelector('#loading-spinner').style.display = 'block';
    
    // Mock API call
    const response = await fetch('https://mockapi.io/events');
    const data = await response.json();
    
    // Process and display events
    const newEvents = data.map(item => ({
      id: item.id,
      name: item.name,
      date: item.date,
      seats: item.seats,
      category: item.category
    }));
    
    events.push(...newEvents);
    renderEvents(events);
  } catch (error) {
    console.error("Failed to fetch events:", error);
    alert("Failed to load events. Please try again later.");
  } finally {
    document.querySelector('#loading-spinner').style.display = 'none';
  }
}

// ===== 10. Modern JavaScript Features =====
function createEvent({ name, date, seats = 20, category = 'general' }) {
  return { name, date, seats, category };
}

// Using spread operator to clone before filtering
function filterEventsByDate(targetDate) {
  const eventsCopy = [...events];
  return eventsCopy.filter(event => event.date === targetDate);
}

// ===== 11. Working with Forms =====
document.querySelector('#registration-form').addEventListener('submit', (e) => {
  e.preventDefault();
  
  const form = e.target;
  const name = form.elements['name'].value;
  const email = form.elements['email'].value;
  const eventId = parseInt(form.elements['event'].value);
  
  // Simple validation
  if (!name || !email || !eventId) {
    showFormError("Please fill all fields");
    return;
  }
  
  if (!validateEmail(email)) {
    showFormError("Please enter a valid email");
    return;
  }
  
  // Process registration
  if (eventManager.registerUser(eventId)) {
    showFormSuccess("Registration successful!");
    form.reset();
  } else {
    showFormError("Registration failed. No seats available.");
  }
});

function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function showFormError(message) {
  const errorElement = document.querySelector('#form-error');
  errorElement.textContent = message;
  errorElement.style.display = 'block';
}

function showFormSuccess(message) {
  const successElement = document.querySelector('#form-success');
  successElement.textContent = message;
  successElement.style.display = 'block';
  setTimeout(() => {
    successElement.style.display = 'none';
  }, 3000);
}

// ===== 12. AJAX & Fetch API =====
async function submitRegistration(userData) {
  try {
    const response = await fetch('https://mockapi.io/registrations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
    });
    
    if (!response.ok) throw new Error('Network response was not ok');
    
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error submitting registration:', error);
    throw error;
  }
}

// ===== 13. Debugging and Testing =====
// Example debug logging
function debugRegistration(eventId, userId) {
  console.group('Registration Debug');
  console.log('Attempting registration for:', { eventId, userId });
  console.table(events.find(e => e.id === eventId));
  
  try {
    const success = eventManager.registerUser(eventId);
    console.log('Registration result:', success);
    return success;
  } catch (error) {
    console.error('Registration error:', error);
    throw error;
  } finally {
    console.groupEnd();
  }
}

// ===== 14. jQuery and JS Frameworks =====
// Example jQuery implementation (would need jQuery library loaded)
/*
$(document).ready(function() {
  $('#registerBtn').click(function() {
    $(this).fadeOut(200, function() {
      alert("Registration in progress...");
      $(this).fadeIn(200);
    });
  });
  
  // Benefit of frameworks like React/Vue:
  // Component-based architecture makes UI more maintainable and reusable
});
