// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAWXflFFAj-gMweIXOuhHQy5bLWS7y7rOA",
  authDomain: "runrecruit-1f28a.firebaseapp.com",
  projectId: "runrecruit-1f28a",
  storageBucket: "runrecruit-1f28a.firebasestorage.app",
  messagingSenderId: "799884349482",
  appId: "1:799884349482:web:542666c35c8763847bf353",
  measurementId: "G-DNJ4JKJVSB"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);