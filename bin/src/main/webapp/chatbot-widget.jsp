<div class="ai-chatbot-widget is-collapsed" id="aiChatbotWidget">
	<button
		class="ai-chatbot-launcher btn btn-primary rounded-circle shadow-lg d-flex align-items-center justify-content-center"
		type="button" id="aiChatbotLauncher" aria-label="Open AI chatbot">
		<i class="bi bi-robot fs-3"></i>
	</button>

	<div class="ai-chatbot-panel card border-0 shadow-lg rounded-4 d-none"
		id="aiChatbotPanel">
		<div
			class="ai-chatbot-header card-header bg-primary text-white rounded-top-4 d-flex align-items-center justify-content-between"
			id="aiChatbotHeader">
			<div class="d-flex align-items-center gap-2">
				<span
					class="bg-white text-primary rounded-circle d-flex align-items-center justify-content-center"
					style="width: 32px; height: 32px;">
					<i class="bi bi-robot"></i>
				</span>
				<div>
					<h6 class="mb-0 fw-bold">AI Chatbot</h6>
					<small class="opacity-75">Financial assistant</small>
				</div>
			</div>

			<button class="btn btn-sm btn-light rounded-circle" type="button"
				id="aiChatbotToggle" aria-label="Close chatbot">
				<i class="bi bi-dash-lg"></i>
			</button>
		</div>

		<div class="ai-chatbot-body card-body p-3" id="aiChatbotBody">
			<div class="ai-chatbot-messages bg-light rounded-4 p-3 mb-3"
				id="aiChatbotMessages">
				<div class="d-flex gap-2 mb-3">
					<div
						class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center flex-shrink-0"
						style="width: 32px; height: 32px;">
						<i class="bi bi-robot"></i>
					</div>
					<div class="bg-white border rounded-4 p-2 shadow-sm small">
						Hi! Ask me about cashflow, expenses, or profit suggestions.
					</div>
				</div>
			</div>

			<form id="aiChatbotForm">
				<div class="input-group">
					<input class="form-control rounded-start-pill" id="aiChatbotInput"
						type="text" placeholder="Type your question...">
					<button class="btn btn-primary rounded-end-pill px-3" type="submit">
						<i class="bi bi-send"></i>
					</button>
				</div>
			</form>
		</div>
	</div>
</div>
