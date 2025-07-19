// application.js
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";

// Import controllers
import SquaresController from "./controllers/squares_controller.js";
import BingoGamesController from "./controllers/bingo_games_controller.js";

// Start Stimulus
const application = Application.start();

// Configure Stimulus
application.debug = process.env.NODE_ENV === "development";
window.Stimulus = application;

// Register controllers
application.register("squares", SquaresController);
application.register("bingo-games", BingoGamesController);

export { application };
