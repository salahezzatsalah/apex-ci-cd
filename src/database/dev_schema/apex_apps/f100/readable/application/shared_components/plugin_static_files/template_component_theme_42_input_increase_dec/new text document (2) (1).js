function getVal(item) {
  if (!item || item === "#" || item === "#INPUT#") return 0; // prevent jQuery error
  try {
    return parseInt(apex.item(item).getValue()) || 0;
  } catch (e) {
    console.warn("Item not found:", item);
    return 0;
  }
}

function setVal(item, val) {
  if (!item || item === "#" || item === "#INPUT#") return; // skip invalid placeholders

  try {
    apex.item(item).setValue(val);
  } catch (e) {
    console.warn("Item not found:", item);
  }

  // Update visible display field
  const disp = document.getElementById("disp_" + item);
  if (disp) disp.value = val;

  // Update button states (unique IDs per item)
  const decBtn = document.getElementById("decBtn_" + item);
  const incBtn = document.getElementById("incBtn_" + item);
  if (decBtn) decBtn.disabled = (val <= 1);
  if (incBtn) incBtn.disabled = (val >= 99); // optional max
}

function incValue(item) {
  setVal(item, getVal(item) + 1);
}

function decValue(item) {
  const v = getVal(item);
  if (v > 1) setVal(item, v - 1);
}

// Initialize on load
document.addEventListener("DOMContentLoaded", function() {
  const items = document.querySelectorAll("[id^='disp_']");
  items.forEach((disp) => {
    const item = disp.id.replace("disp_", "");
    const currentVal = getVal(item);
    setVal(item, currentVal);
  });
});
