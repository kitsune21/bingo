import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea"];
  static values = { bingoGameId: Number }; // Define the value

  // You could debounce this if you prefer.
  // This method will be called when a textarea loses focus (blur)
  // or on every input (input) if you change data-action.
  updateContent(event) {
    console.log("updating stuff");
    const textarea = event.target;
    const content = textarea.value;
    const ordering = textarea.dataset.squareOrdering;
    let squareId = textarea.dataset.squareId;
    const bingoGameId = this.bingoGameIdValue; // Use the defined value

    let url;
    let method;

    if (squareId && squareId !== "null") {
      url = `/bingo_games/${bingoGameId}/squares/${squareId}`;
      method = "PUT";
    } else {
      url = `/bingo_games/${bingoGameId}/squares`;
      method = "POST";
    }

    fetch(url, {
      method: method,
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({
        square: {
          content: content,
          ordering: ordering,
        },
      }),
    })
      .then((response) => {
        if (!response.ok) {
          // Handle non-2xx responses
          return response.json().then((err) => {
            throw new Error(
              err.errors ? err.errors.join(", ") : "Unknown error"
            );
          });
        }
        return response.json();
      })
      .then((data) => {
        if (data.status === "success") {
          if (method === "POST" && data.square_id) {
            textarea.dataset.squareId = data.square_id; // Update squareId for future updates
          }
          console.log("Square updated/created successfully:", data);
          // Optionally add a visual cue for success (e.g., a green border for a moment)
        } else {
          console.error("Error updating/creating square:", data.errors);
          alert("Failed to update square: " + data.errors.join(", "));
          // Optionally revert textarea content or show error state
        }
      })
      .catch((error) => {
        console.error("Network or server error:", error.message);
        alert("Network or server error: " + error.message);
      });
  }
}
