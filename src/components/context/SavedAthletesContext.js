import React, { createContext, useContext, useState, useEffect } from "react";
import { doc, setDoc, getDoc } from "firebase/firestore";
import { db } from "../firebaseConfig";
import { useAuth } from "./AuthContext";

const SavedAthletesContext = createContext();

export function SavedAthletesProvider({ children }) {
  const { user } = useAuth();
  const [savedAthletes, setSavedAthletes] = useState([]);

  const loadAthletes = async () => {
    if (user) {
      const docRef = doc(db, "savedAthletes", user.uid);
      const docSnap = await getDoc(docRef);
      if (docSnap.exists()) {
        setSavedAthletes(docSnap.data().athletes || []);
      }
    }
  };

  const saveAthletesToDb = async (athletes) => {
    if (user) {
      await setDoc(doc(db, "savedAthletes", user.uid), { athletes });
    }
  };

  const addAthlete = (athlete) => {
    const updated = [...savedAthletes, athlete];
    setSavedAthletes(updated);
    saveAthletesToDb(updated);
  };

  const unsaveAthlete = (athleteId) => {
    const updated = savedAthletes.filter((a) => a.id !== athleteId);
    setSavedAthletes(updated);
    saveAthletesToDb(updated);
  };

  useEffect(() => {
    loadAthletes();
  }, [user]);

  return (
    <SavedAthletesContext.Provider value={{ savedAthletes, addAthlete, unsaveAthlete }}>
      {children}
    </SavedAthletesContext.Provider>
  );
}

export function useSavedAthletes() {
  return useContext(SavedAthletesContext);
}
