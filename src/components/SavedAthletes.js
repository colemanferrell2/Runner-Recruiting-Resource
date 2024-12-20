import React from "react";
import { Box, Typography, Button } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import { useSavedAthletes } from "./context/SavedAthletesContext";

const columns = (unsaveAthlete) => [
  { field: "rank", headerName: "Rank", width: 90 },
  { field: "name", headerName: "Name", width: 200 },
  { field: "classYear", headerName: "Class Year", width: 130 },
  { field: "state", headerName: "State", width: 100 },
  { field: "school", headerName: "School", width: 200 },
  { field: "event", headerName: "Event", width: 150 },
  { field: "time", headerName: "Time", width: 100 },
  { field: "score", headerName: "Score", width: 100 },
  {
    field: "unsave",
    headerName: "Unsave",
    width: 150,
    renderCell: (params) => (
      <Button variant="contained" color="error" onClick={() => unsaveAthlete(params.row.id)}>
        Unsave
      </Button>
    ),
  },
];

const SavedAthletes = () => {
  const { savedAthletes, unsaveAthlete } = useSavedAthletes();

  return (
    <Box sx={{ padding: 2 }}>
      <Typography variant="h4" sx={{ marginBottom: 2 }}>
        Saved Athletes
      </Typography>
      <Box sx={{ height: 400, width: "100%" }}>
        {savedAthletes.length > 0 ? (
          <DataGrid rows={savedAthletes} columns={columns(unsaveAthlete)} pageSize={5} />
        ) : (
          <Typography>No athletes saved.</Typography>
        )}
      </Box>
    </Box>
  );
};

export default SavedAthletes;
