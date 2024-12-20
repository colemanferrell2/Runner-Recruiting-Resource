import React from "react";
import { Box, Typography } from "@mui/material";

const Footer = () => {
  return (
    <Box
      sx={{
        backgroundColor: "#1a73e8",
        color: "#fff",
        textAlign: "center",
        padding: 2,
        marginTop: 4,
      }}
    >
      <Typography variant="body1">© 2024 Run Recruit. All Rights Reserved.</Typography>
    </Box>
  );
};

export default Footer;
