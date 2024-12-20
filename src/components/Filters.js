import React from "react";
import { Box, Typography, Select, MenuItem, Slider, Checkbox, FormControlLabel } from "@mui/material";

function Filters({
  states,
  selectedState,
  onStateChange,
  classYears,
  selectedClassYears,
  onClassYearChange,
  stars,
  selectedStars,
  onStarChange,
  scoreRange,
  onScoreChange
}) {
  return (
    <Box sx={{ marginBottom: 3, display: "flex", flexDirection: "column", gap: 2 }}>
      {/* State Filter */}
      <Box>
        <Typography>Filter by State:</Typography>
        <Select
          value={selectedState}
          onChange={(e) => onStateChange(e.target.value)}
          displayEmpty
          sx={{ width: 200 }}
        >
          <MenuItem value="">All States</MenuItem>
          {states.map((state) => (
            <MenuItem key={state} value={state}>
              {state}
            </MenuItem>
          ))}
        </Select>
      </Box>

      {/* Class Year Filter */}
      <Box>
        <Typography>Filter by Class Year:</Typography>
        {classYears.map((year) => (
          <FormControlLabel
            key={year}
            control={
              <Checkbox
                checked={selectedClassYears.includes(year)}
                onChange={(e) => {
                  if (e.target.checked) {
                    onClassYearChange([...selectedClassYears, year]);
                  } else {
                    onClassYearChange(selectedClassYears.filter((y) => y !== year));
                  }
                }}
              />
            }
            label={year}
          />
        ))}
      </Box>

      {/* Star Ratings Filter */}
      <Box>
        <Typography>Filter by Stars:</Typography>
        {stars.map((star) => (
          <FormControlLabel
            key={star}
            control={
              <Checkbox
                checked={selectedStars.includes(star)}
                onChange={(e) => {
                  if (e.target.checked) {
                    onStarChange([...selectedStars, star]);
                  } else {
                    onStarChange(selectedStars.filter((s) => s !== star));
                  }
                }}
              />
            }
            label={`${"★".repeat(star)}`}
          />
        ))}
      </Box>

      {/* Score Range Filter */}
      <Box>
        <Typography>Filter by Score:</Typography>
        <Slider
          value={scoreRange}
          onChange={(e, newValue) => onScoreChange(newValue)}
          valueLabelDisplay="auto"
          min={0}
          max={115}
        />
      </Box>
    </Box>
  );
}

export default Filters;
