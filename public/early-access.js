(() => {
  const form = document.querySelector("#early-access-form");
  const status = document.querySelector("#form-status");

  if (!form || !status) {
    return;
  }

  const params = new URLSearchParams(window.location.search);
  const role = params.get("role");
  if (role && form.elements.role) {
    form.elements.role.value = role;
  }

  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    status.textContent = "Sending your request...";
    form.querySelector("button[type='submit']").disabled = true;

    try {
      const response = await fetch(endpointForCurrentEnvironment(form), {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-MySLI-Request-ID": requestId()
        },
        body: JSON.stringify(formPayload(form))
      });
      const body = await response.json().catch(() => ({}));

      if (!response.ok) {
        throw new Error(body.error || "Could not submit your request.");
      }

      form.reset();
      status.textContent = "Thanks. MySLI received your early access request.";
      status.classList.remove("error-text");
      status.classList.add("success-text");
    } catch (error) {
      status.textContent = error.message || "Could not submit your request. Email support@mysli.network instead.";
      status.classList.remove("success-text");
      status.classList.add("error-text");
      form.querySelector("button[type='submit']").disabled = false;
    }
  });

  function endpointForCurrentEnvironment(formElement) {
    const requestedEnvironment = params.get("env");
    if (requestedEnvironment === "staging") {
      return formElement.dataset.stagingEndpoint;
    }
    return formElement.dataset.productionEndpoint;
  }

  function formPayload(formElement) {
    const formData = new FormData(formElement);
    return {
      role: value(formData, "role"),
      name: value(formData, "name"),
      email: value(formData, "email"),
      phone: value(formData, "phone"),
      stateOrRegion: value(formData, "stateOrRegion"),
      specialtyOrUseCase: value(formData, "specialtyOrUseCase"),
      organizationName: value(formData, "organizationName"),
      organizationType: value(formData, "organizationType"),
      organizationContactRole: value(formData, "organizationContactRole"),
      departmentsOrLocations: value(formData, "departmentsOrLocations"),
      expectedMonthlySessions: value(formData, "expectedMonthlySessions"),
      urgency: value(formData, "urgency"),
      interpreterCredentialStatus: value(formData, "interpreterCredentialStatus"),
      interpreterAvailability: value(formData, "interpreterAvailability"),
      interpreterPreferredDevice: value(formData, "interpreterPreferredDevice"),
      preferredContactMethod: value(formData, "preferredContactMethod"),
      notes: value(formData, "notes"),
      website: value(formData, "website"),
      source: value(formData, "source"),
      campaign: value(formData, "campaign"),
      consentGiven: formData.get("consentGiven") === "on",
      noSensitiveDetailsAcknowledged: formData.get("noSensitiveDetailsAcknowledged") === "on"
    };
  }

  function value(formData, key) {
    return String(formData.get(key) || "").trim();
  }

  function requestId() {
    const entropy = Math.random().toString(36).slice(2, 10);
    return `web-lead-${Date.now().toString(36)}-${entropy}`;
  }
})();
