import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea", "percentageCompleted"];
  static values = { bingoGameId: Number };

  connect() {
    console.log("Squares controller connected!");
  }

  async updateCompleted(event) {
    const button = event.target;
    const squareId = button.dataset.squareId;
    const completedSquare = JSON.parse(button.dataset.completed);
    const newCompleted = !completedSquare;
    const bingoGameId = this.bingoGameIdValue;

    const url = `/bingo_games/${bingoGameId}/squares/${squareId}`;

    fetch(url, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({
        square: {
          completed: newCompleted,
        },
      }),
    })
      .then((response) => {
        if (!response.ok) {
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
          console.log("Square updated successfully:", data);
          button.dataset.completed = newCompleted;

          if (newCompleted) {
            button.classList.add("completed-square");
          } else {
            button.classList.remove("completed-square");
          }

          if (this.hasPercentageCompletedTarget) {
            this.percentageCompletedTarget.innerText =
              data.percentage_completed;
          }
        } else {
          console.error("Error updating square:", data.errors);
          alert("Failed to update square: " + data.errors.join(", "));
        }
      })
      .catch((error) => {
        console.error("Network or server error:", error.message);
        alert("Network or server error: " + error.message);
      });
  }

  updateContent(event) {
    const textarea = event.target;
    const content = textarea.value;
    const ordering = textarea.dataset.squareOrdering;
    let squareId = textarea.dataset.squareId;
    const bingoGameId = this.bingoGameIdValue;
    const isCompleted = JSON.parse(textarea.dataset.completed) ? false : false;

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
          completed: isCompleted,
        },
      }),
    })
      .then((response) => {
        if (!response.ok) {
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
            textarea.dataset.squareId = data.square_id;
          }
          console.log("Square updated/created successfully:", data);
        } else {
          console.error("Error updating/creating square:", data.errors);
          alert("Failed to update square: " + data.errors.join(", "));
        }
      })
      .catch((error) => {
        console.error("Network or server error:", error.message);
        alert("Network or server error: " + error.message);
      });
  }
}
