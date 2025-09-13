<p align="left">
  <a href="https://www.mathworks.com/products/matlab.html"><img src="https://img.shields.io/badge/MATLAB-R2022a%2B-blue" alt="MATLAB"></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-success" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/maintained-yes-informational" alt="Maintained">
</p>

![MATLAB](https://img.shields.io/badge/MATLAB-R2022a+-orange)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/<your-username>/<repo>)

# Radar Analysis Tools

MATLAB scripts for analyzing radar measurement accuracy and waveform performance.

## Contents
- `scripts/radar_residual_accuracy_dashboard.m` – Residual accuracy dashboard & figure export
- `scripts/Radar_theoretical_max_accuracy_formulas.m`
- `scripts/Radar_theoretical_max_accuracy_formulas_waveforms.m`
- `scripts/SDA_theoretical_test.m`

## Quickstart
```matlab
% From this folder
run_demo
```

## Example Results
![Range Over Time](results/range_time.png)
![Residuals](results/residuals_hist.png)


## Accuracy Thresholds & Tuning

The residual dashboard reports **bias (μ)**, **standard deviation (σ)**, **RMS**, and the **percent of samples within a threshold** for each channel:

- **Azimuth / Elevation:** default ±0.04°
- **Range:** default ±0.03 km
- **Range-rate:** default ±2 m/s

You can tune these limits directly at the top of
`scripts/radar_residual_accuracy_dashboard.m`:
```matlab
% --- Configurable thresholds ---
az_thresh_deg   = 0.04;  % azimuth (deg)
el_thresh_deg   = 0.04;  % elevation (deg)
range_thresh_km = 0.03;  % range (km)
rr_thresh_mps   = 2.0;   % range rate (m/s)
```

After editing, re-run:
```matlab
run_demo
```
The figure (`results/residual_accuracy_dashboard.png`) will regenerate using your updated thresholds.



## Requirements
- MATLAB R2022a or newer
- Recommended: Signal Processing Toolbox (for radar), Aerospace/Mapping toolboxes as noted


## Installation
```bash
git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>
```


## Data
Place required CSVs into the `data/` folder. See Quickstart for filenames.


## Results
Figures are saved under `results/`.

---

### 🤝 Contributing
Issues and PRs are welcome. Please open an issue to discuss significant changes.

### 📜 License
This project is licensed under the MIT License — see [LICENSE](./LICENSE) for details.

### ⭐ Acknowledgments
If this saved you time, consider giving the repo a star!
