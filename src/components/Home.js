import React from "react";
import { Box, Typography, Button } from "@mui/material";

const Home = () => {
  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        height: "100vh",
        background: "linear-gradient(to right, #1a73e8, #f50057)",
        color: "#fff",
      }}
    >
      <Typography variant="h2" sx={{ fontWeight: "bold", marginBottom: 2 }}>
        Welcome to Run Recruit
      </Typography>
      <Typography variant="h5" sx={{ marginBottom: 4, textAlign: "center", maxWidth: "600px" }}>
        Discover and track top athletes. Save your favorites and stay on top of the leaderboard!
      </Typography>
      <Button
        variant="contained"
        color="secondary"
        size="large"
        sx={{ fontWeight: "bold" }}
        href="/rankings"
      >
        Explore Rankings
      </Button>
    </Box>
  );
};

export default Home;
