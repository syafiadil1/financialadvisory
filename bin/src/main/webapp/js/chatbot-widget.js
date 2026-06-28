(function () {
	const widget = document.getElementById("aiChatbotWidget");
	const launcher = document.getElementById("aiChatbotLauncher");
	const panel = document.getElementById("aiChatbotPanel");
	const toggle = document.getElementById("aiChatbotToggle");
	const form = document.getElementById("aiChatbotForm");
	const input = document.getElementById("aiChatbotInput");
	const messages = document.getElementById("aiChatbotMessages");

	if (!widget) {
		return;
	}

	if (launcher) {
		launcher.addEventListener("click", function () {
			widget.classList.remove("is-collapsed");
			launcher.classList.add("d-none");

			if (panel) {
				panel.classList.remove("d-none");
			}

			if (input) {
				input.focus();
			}
		});
	}

	if (toggle) {
		toggle.addEventListener("click", function () {
			widget.classList.add("is-collapsed");
			launcher.classList.remove("d-none");

			if (panel) {
				panel.classList.add("d-none");
			}
		});
	}

	if (form && input && messages) {
		form.addEventListener("submit", function (event) {
			event.preventDefault();

			const question = input.value.trim();

			if (!question) {
				return;
			}

			addMessage(question, "user");
			input.value = "";

			setTimeout(function () {
				addMessage("This is a simple demo chatbot. For now, review revenue, expenses, and net profit before making a financial decision.", "bot");
			}, 400);
		});
	}

	function addMessage(text, sender) {
		const wrapper = document.createElement("div");
		wrapper.className = sender === "user"
			? "d-flex justify-content-end mb-3"
			: "d-flex gap-2 mb-3";

		if (sender === "bot") {
			wrapper.innerHTML =
				'<div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 32px; height: 32px;">' +
				'<i class="bi bi-robot"></i>' +
				'</div>' +
				'<div class="bg-white border rounded-4 p-2 shadow-sm small"></div>';
		} else {
			wrapper.innerHTML = '<div class="bg-primary text-white rounded-4 p-2 shadow-sm small"></div>';
		}

		wrapper.querySelector(".small").textContent = text;
		messages.appendChild(wrapper);
		messages.scrollTop = messages.scrollHeight;
	}
}());
