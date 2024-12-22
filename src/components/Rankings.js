import React, { useState, useEffect } from "react";
import { DataGrid } from "@mui/x-data-grid";
import { Box, Typography, Button } from "@mui/material";
import Filters from "./Filters";
import axios from "axios"; // You may want to use axios for API calls
import { useSavedAthletes } from "./context/SavedAthletesContext";

const columns = (toggleSaveAthlete, savedAthletes) => [
  { field: "rank", headerName: "Rank", width: 90 },
  { field: "name", headerName: "Name", width: 200 },
  { field: "classYear", headerName: "Class Year", width: 130 },
  { field: "state", headerName: "State", width: 100 },
  { field: "school", headerName: "School", width: 200 },
  { field: "event", headerName: "Event", width: 150 },
  { field: "time", headerName: "Time", width: 100 },
  { field: "score", headerName: "Score", width: 100 },
  {
    field: "save",
    headerName: "Save/Unsave",
    width: 150,
    renderCell: (params) => {
      const isSaved = savedAthletes.some((athlete) => athlete.id === params.row.id);
      return (
        <Button
          variant="contained"
          color={isSaved ? "success" : "primary"}
          onClick={() => toggleSaveAthlete(params.row)}
        >
          {isSaved ? "Saved" : "Save"}
        </Button>
      );
    },
  },
];

function Rankings({ apiUrl }) {
  const [rows, setRows] = useState([]);
  const [selectedState, setSelectedState] = useState("");
  const [selectedClassYear, setSelectedClassYear] = useState([]);
  const [selectedStars, setSelectedStars] = useState([]);
  const [scoreRange, setScoreRange] = useState([0, 115]);
  const [loading, setLoading] = useState(true);

  const { savedAthletes, toggleSaveAthlete } = useSavedAthletes();

  useEffect(() => {
    // Fetch data from Cloud Run API
    axios
      .get(`https://plumber-api-service-296748539603.us-central1.run.app/finalMenBestE`) // Replace with the correct endpoint
      .then((response) => {
        const data = response.data.map((item, index) => ({
          id: index + 1,
          rank: item.Rank,
          name: item.Name,
          classYear: item.Class,
          state: item.State,
          school: item.School,
          event: item.Event,
          time: item.Time,
          score: item.Score,
        }));
        setRows(data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error loading data:", error);
        setLoading(false);
      });
  }, [apiUrl]);

  const filteredRows = rows.filter((row) => {
    const stateMatch = !selectedState || row.state === selectedState;
    const classYearMatch = selectedClassYear.length === 0 || selectedClassYear.includes(row.classYear);
    const scoreMatch = row.score >= scoreRange[0] && row.score <= scoreRange[1];
    return stateMatch && classYearMatch && scoreMatch;
  });

  const uniqueStates = [...new Set(rows.map((row) => row.state))].filter(Boolean);

  return (
    <Box sx={{ padding: 2 }}>
      <Typography variant="h4" sx={{ marginBottom: 2 }}>
        Rankings
      </Typography>

      <Filters
        states={uniqueStates}
        selectedState={selectedState}
        onStateChange={setSelectedState}
        classYears={[2025, 2026, 2027, 2028]}
        selectedClassYears={selectedClassYear}
        onClassYearChange={setSelectedClassYear}
        stars={[1, 2, 3, 4, 5]}
        selectedStars={selectedStars}
        onStarChange={setSelectedStars}
        scoreRange={scoreRange}
        onScoreChange={setScoreRange}
      />

      <Box sx={{ height: 400, width: "100%" }}>
        {loading ? (
          <Typography>Loading...</Typography>
        ) : (
          <DataGrid rows={filteredRows} columns={columns(toggleSaveAthlete, savedAthletes)} pageSize={5} />
        )}
      </Box>
    </Box>
  );
}

export default Rankings;
