import React from "react";
import logo from "./logo.svg";
import "./App.css";
import { AppProvider } from "./contexts/AppContext";
// import { Toaster } from "react-hot-toast";
import Routers from "./routers";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  useRoutes,
} from "react-router-dom";
function App() {
  return (
    <AppProvider>
      <React.Fragment>
        <Router>
          <Routers />
        </Router>
        {/* <Toaster />
      abc */}
        <div className="App">
          <header className="App-header">
            <img src={logo} className="App-logo" alt="logo" />
            <p>
              Edit <code>src/App.tsx</code> and save to reload.
            </p>
            <a
              className="App-link"
              href="https://reactjs.org"
              target="_blank"
              rel="noopener noreferrer"
            >
              Learn React
            </a>
          </header>
        </div>
      </React.Fragment>
    </AppProvider>
  );
}

export default App;
