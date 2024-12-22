import React from "react";
import { BrowserRouter as Router, Route, Routes, Link } from "react-router-dom";
import { AppBar, Toolbar, Typography, Button, Container } from "@mui/material";
import { ThemeProvider } from "@mui/material/styles";
import theme from "./components/Theme";
import { AuthProvider } from "./components/context/AuthContext";
import { SavedAthletesProvider } from "./components/context/SavedAthletesContext";
import Home from "./components/Home";
import Rankings from "./components/Rankings";
import Scoring from "./components/Scoring";
import SavedAthletes from "./components/SavedAthletes";
import Footer from "./components/Footer";
import "./App.css";
import LoginPage from "./components/LoginPage";
import ProtectedRoute from "./components/ProtectedRoute";

// API URL from Cloud Run (replace with your Cloud Run URL)
const apiUrl = process.env.REACT_APP_API_URL || "https://my-cloud-run-service-296748539603.us-central1.run.app"; // Replace with your Cloud Run URL

function App() {
  return (
    <ThemeProvider theme={theme}>
      <AuthProvider>
        <SavedAthletesProvider>
          <Router>
            <div className="App">
              <AppBar position="static">
                <Toolbar>
                  <Typography variant="h6" sx={{ flexGrow: 1 }}>
                    Run Recruit
                  </Typography>
                  <Button color="inherit" component={Link} to="/">
                    Home
                  </Button>
                  <Button color="inherit" component={Link} to="/rankings">
                    Rankings
                  </Button>
                  <Button color="inherit" component={Link} to="/scoring">
                    Scoring
                  </Button>
                  <Button color="inherit" component={Link} to="/saved">
                    Saved Athletes
                  </Button>
                  <Button color="inherit" component={Link} to="/login">
                    Login
                  </Button>
                </Toolbar>
              </AppBar>
              <Container sx={{ marginTop: 4 }}>
                <Routes>
                  <Route path="/" element={<Home />} />
                  <Route path="/login" element={<LoginPage />} />
                  <Route
                    path="/rankings"
                    element={
                      <Rankings apiUrl={apiUrl} /> // Pass apiUrl to Rankings component
                    }
                  />
                  <Route
                    path="/scoring"
                    element={
                      <ProtectedRoute>
                        <Scoring apiUrl={apiUrl} />
                      </ProtectedRoute>
                    }
                  />
                  <Route
                    path="/saved"
                    element={
                      <ProtectedRoute>
                        <SavedAthletes apiUrl={apiUrl} /> 
                      </ProtectedRoute>
                    }
                  />
                </Routes>
              </Container>
              <Footer />
            </div>
          </Router>
        </SavedAthletesProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}

export default App;
