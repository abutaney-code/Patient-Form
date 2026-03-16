<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Patient Tracker</title>
  <style>
    /* Styling for the page layout */
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      height: 100vh;
      margin: 0;
      background-color: #f9f9f9;
    }

    /* Sidebar styling */
    #sidebar {
      width: 300px;
      background: #ffffff;
      padding: 20px;
      border-right: 2px solid #e0e0e0;
      box-shadow: 2px 0 5px rgba(0,0,0,0.05);
      overflow-y: auto;
    }

    /* Main content styling */
    #main-content {
      flex-grow: 1;
      padding: 40px;
      background-color: #f9f9f9;
    }

    h2, h3 { color: #333; }

    /* Form and button styling */
    .form-group { margin-bottom: 15px; }
    
    input[type="text"] {
      width: 100%;
      padding: 10px;
      box-sizing: border-box;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    button {
      width: 100%;
      padding: 10px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-weight: bold;
    }

    button:hover { background-color: #0056b3; }

    /* Patient list styling */
    #patient-list { margin-top: 20px; }
    
    .patient-item {
      padding: 12px;
      border-bottom: 1px solid #eee;
      cursor: pointer;
      border-radius: 4px;
    }

    .patient-item:hover { background-color: #f1f1f1; }

    /* Utility classes */
    .hidden { display: none; }
    
    .card {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      max-width: 500px;
    }

    /* Medication list styling */
    #medication-list {
      background: #fdfdfd;
      border: 1px solid #eee;
      padding: 15px 15px 15px 35px;
      border-radius: 4px;
    }
  </style>
</head>
<body>

  <div id="sidebar">
    <h3>Add New Patient</h3>
    <div class="form-group">
      <input type="text" id="new-name" placeholder="Patient Name (e.g., John Doe)">
    </div>
    <div class="form-group">
      <input type="text" id="new-weight" placeholder="Weight (e.g., 180 lbs)">
    </div>
    <button onclick="addPatient()">Add Patient</button>

    <hr style="margin: 25px 0; border: 1px solid #eee;">

    <h3>Patient Roster</h3>
    <div id="patient-list">
      </div>
  </div>

  <div id="main-content">
    
    <div id="empty-state">
      <h2>Select a patient from the left to view their details.</h2>
    </div>

    <div id="patient-details" class="card hidden">
      <h2 id="display-name">Patient Name</h2>
      <p style="font-size: 1.2em;"><strong>Weight:</strong> <span id="display-weight"></span></p>

      <hr style="border: 1px solid #eee; margin: 20px 0;">

      <h3>Medications</h3>
      <ul id="medication-list">
        </ul>

      <div class="form-group" style="margin-top: 20px;">
        <input type="text" id="new-medication" placeholder="Type a medication name...">
      </div>
      <button onclick="addMedication()">Add Medication</button>
    </div>

  </div>

  <script>
    // 1. Load data from localStorage OR start with an empty array if nothing is saved
    let patients = JSON.parse(localStorage.getItem('patientData')) || [];
    let currentPatientId = null;

    // Call this immediately to show any saved patients when the page first loads
    renderSidebar();

    // 2. New function: Saves the current 'patients' array to the browser's storage
    function saveData() {
      localStorage.setItem('patientData', JSON.stringify(patients));
    }

    // 3. Add a new patient
    function addPatient() {
      const nameInput = document.getElementById('new-name');
      const weightInput = document.getElementById('new-weight');
      
      const name = nameInput.value.trim();
      const weight = weightInput.value.trim();

      if (name !== '' && weight !== '') {
        const newPatient = {
          id: Date.now(),
          name: name,
          weight: weight,
          medications: []
        };

        patients.push(newPatient);
        
        // Save to browser memory right after adding!
        saveData();

        nameInput.value = '';
        weightInput.value = '';
        renderSidebar();
      } else {
        alert("Please enter both a name and a weight.");
      }
    }

    // 4. Update the sidebar
    function renderSidebar() {
      const listContainer = document.getElementById('patient-list');
      listContainer.innerHTML = ''; 

      patients.forEach(patient => {
        const div = document.createElement('div');
        div.className = 'patient-item';
        div.innerText = patient.name;
        div.onclick = () => selectPatient(patient.id);
        listContainer.appendChild(div);
      });
    }

    // 5. Select and display a patient
    function selectPatient(id) {
      currentPatientId = id;
      const patient = patients.find(p => p.id === id);

      document.getElementById('empty-state').classList.add('hidden');
      document.getElementById('patient-details').classList.remove('hidden');

      document.getElementById('display-name').innerText = patient.name;
      document.getElementById('display-weight').innerText = patient.weight;

      renderMedications();
    }

    // 6. Add a medication
    function addMedication() {
      if (!currentPatientId) return;

      const medInput = document.getElementById('new-medication');
      const medName = medInput.value.trim();

      if (medName !== '') {
        const patient = patients.find(p => p.id === currentPatientId);
        patient.medications.push(medName); 
        
        // Save to browser memory right after modifying the medication list!
        saveData();

        medInput.value = ''; 
        renderMedications(); 
      }
    }

    // 7. Render medications list
    function renderMedications() {
      const patient = patients.find(p => p.id === currentPatientId);
      const medList = document.getElementById('medication-list');
      
      medList.innerHTML = ''; 

      if (patient.medications.length === 0) {
        medList.innerHTML = '<li>No medications added yet.</li>';
      } else {
        patient.medications.forEach(med => {
          const li = document.createElement('li');
          li.innerText = med;
          medList.appendChild(li);
        });
      }
    }
  </script>
</body>
</html>
