import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea", "percentageCompleted"];
  static values = { bingoGameId: Number };

  connect() {
    console.log("Squares controller connected!");
  }

  checkForNumbers(event) {
    const { value, id } = event.target;
    const numberPattern = /[0-9]+/g;

    const quantityInputWrapper = document.getElementById(`${id}-input-wrapper`);
    const quantityInput = document.getElementById(`${id}-input`);

    if (quantityInputWrapper && quantityInput) {
      if (numberPattern.test(value)) {
        quantityInputWrapper.style.display = "block";
        quantityInput.value = value.match(numberPattern)[0];
      } else {
        quantityInputWrapper.style.display = "none";
      }
    } else {
      console.warn(`Input with ID ${id}-input not found.`);
    }
  }

  async updateCompleted(event) {
    const button = event.target;
    const squareId = button.dataset.squareId;
    const bingoGameId = this.bingoGameIdValue;

    let currentCompleted = JSON.parse(button.dataset.completed);
    let currentQuantity = parseInt(button.dataset.quantity);
    let currentQuantityCompleted = parseInt(button.dataset.quantityCompleted);

    let newCompletedState;
    let newQuantityCompleted;
    let dataToSend = {};

    if (currentQuantity > 0) {
      if (currentCompleted) {
        newQuantityCompleted = 0;
        newCompletedState = false;
      } else {
        newQuantityCompleted = currentQuantityCompleted + 1;
        if (newQuantityCompleted > currentQuantity) {
          newQuantityCompleted = currentQuantity;
        }
        newCompletedState = newQuantityCompleted === currentQuantity;
      }

      dataToSend = {
        quantity_completed: newQuantityCompleted,
        completed: newCompletedState,
      };
    } else {
      newCompletedState = !currentCompleted;
      dataToSend = {
        completed: newCompletedState,
      };
    }

    const url = `/bingo_games/${bingoGameId}/squares/${squareId}`;

    fetch(url, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({
        square: dataToSend,
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

          button.dataset.completed = newCompletedState;
          if (currentQuantity > 0) {
            button.dataset.quantityCompleted = newQuantityCompleted;

            const quantityDisplay = button
              .closest(".group")
              .querySelector(".quantity-display");
            if (quantityDisplay) {
              quantityDisplay.textContent = `${newQuantityCompleted}/${currentQuantity}`;
            }
          }

          if (newCompletedState) {
            button.classList.add("completed-square");
            if (this.hasPercentageCompletedTarget) {
              this.percentageCompletedTarget.innerText =
                data.percentage_completed;
            }
          } else {
            button.classList.remove("completed-square");
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
    const isCompleted = textarea.dataset.completed === "true";
    const id = textarea.id;
    const quantityInputWrapper = document.getElementById(`${id}-input-wrapper`);
    const quantityInputValue = document.getElementById(`${id}-input`).value;

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
          quantity: quantityInputValue,
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
          quantityInputWrapper.style.display = "none";
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
