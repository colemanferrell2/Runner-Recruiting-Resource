import React, { createContext, useContext, useState, useEffect } from "react";
import { onAuthStateChanged, signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut } from "firebase/auth";
import { auth } from "../firebaseConfig";

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
    });
    return unsubscribe;
  }, []);

  const login = (email, password) => signInWithEmailAndPassword(auth, email, password);

  const signup = (email, password) => createUserWithEmailAndPassword(auth, email, password);

  const logout = () => signOut(auth);

  return (
    <AuthContext.Provider value={{ user, login, signup, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
