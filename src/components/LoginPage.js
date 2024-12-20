import React, { useState } from "react";
import { TextField, Button, Box, Typography } from "@mui/material";
import { useAuth } from "./context/AuthContext";

const LoginPage = () => {
  const { login, signup } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isSignUp, setIsSignUp] = useState(false);

  const handleSubmit = async () => {
    try {
      if (isSignUp) {
        await signup(email, password);
        alert("Account created!");
      } else {
        await login(email, password);
        alert("Logged in!");
      }
    } catch (error) {
      console.error(error.message);
      alert(error.message);
    }
  };

  return (
    <Box sx={{ maxWidth: 400, margin: "auto", mt: 4 }}>
      <Typography variant="h4" sx={{ mb: 2 }}>
        {isSignUp ? "Sign Up" : "Login"}
      </Typography>
      <TextField
        label="Email"
        fullWidth
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        sx={{ mb: 2 }}
      />
      <TextField
        label="Password"
        type="password"
        fullWidth
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        sx={{ mb: 2 }}
      />
      <Button variant="contained" color="primary" fullWidth onClick={handleSubmit}>
        {isSignUp ? "Sign Up" : "Login"}
      </Button>
      <Button fullWidth onClick={() => setIsSignUp(!isSignUp)} sx={{ mt: 2 }}>
        {isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up"}
      </Button>
    </Box>
  );
};

export default LoginPage;
