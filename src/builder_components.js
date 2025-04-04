import { builder } from "@builder.io/react";
import Rankings from "./components/Rankings";

// Register the Rankings component
builder.registerComponent(Rankings, {
  name: "Rankings",
  inputs: [
    {
      name: "apiUrl",
      type: "string",
      required: true,
      helperText: "API URL to fetch rankings data",
    },
  ],
});
