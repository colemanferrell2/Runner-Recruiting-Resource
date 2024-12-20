// Import necessary Firebase modules
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyAWXflFFAj-gMweIXOuhHQy5bLWS7y7rOA",
  authDomain: "runrecruit-1f28a.firebaseapp.com",
  projectId: "runrecruit-1f28a",
  storageBucket: "runrecruit-1f28a.firebasestorage.app",
  messagingSenderId: "799884349482",
  appId: "1:799884349482:web:542666c35c8763847bf353",
  measurementId: "G-DNJ4JKJVSB",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Export Firebase services
export const auth = getAuth(app);
export const db = getFirestore(app);
