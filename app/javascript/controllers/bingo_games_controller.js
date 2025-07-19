import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title", "editField", "editTitle"];

  connect() {
    console.log("BingoGames controller connected!");
  }

  showEditTitle() {
    this.titleTarget.style.display = "none";
    this.editTitleTarget.style.display = "block";
    this.editFieldTarget.focus();
  }

  hideEditTitle() {
    this.titleTarget.style.display = "block";
    this.editTitleTarget.style.display = "none";
  }

  async updateTitle(event) {
    const { success, fetchResponse } = event.detail;

    if (success) {
      this.hideEditTitle();
    } else {
      fetchResponse
        .json()
        .then((errorData) => {
          console.error("Errors:", errorData.errors);
        })
        .catch((e) => console.error("Failed to parse error response:", e));
    }
  }
}
