import { useRoutes } from "react-router-dom";
import HomePage from "../pages/Home";
import React from "react";

const Routers = () => {
  let element = useRoutes([
    { path: "/", element: <HomePage /> },
    { path: "*", element: <div>404</div> },
  ]);
  return element;
};

export default Routers;
// export {};
