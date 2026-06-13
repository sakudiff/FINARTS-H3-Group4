# Data Collection Status — Homework 2 (VAR Analysis of JPY/USD Exchange Rate)

**Generated:** 2026-05-31  
**Target Period:** January 1, 2018 through May 31, 2026  
**Target Frequency:** Daily  

---

## Executive Summary

| Status | Count | Variables |
|--------|-------|-----------|
| ✅ **Daily — Pulled** | 14 of 16 | All major series acquired |
| ⚠️ **Monthly → Daily (forward-filled)** | 1 | Japan 3M CD Rate |
| ❓ **Proxy / Alternative Needed** | 1 | JPY/USD Risk Reversal (25Δ) |

---

## ✅ Section A: Daily Data Successfully Pulled

### A1. FRED (pandas_datareader) — US Series

| File | FRED ID | Frequency | Obs | Date Range |
|------|---------|-----------|-----|------------|
| `FRED_JPY_USD_ExchangeRate.csv` | DEXJPUS | Daily ✅ | 2,190 | 2018-01-02 → 2026-05-29 |
| `FRED_US_3M_TBill_Rate.csv` | DTB3 | Daily ✅ | 2,194 | 2018-01-02 → 2026-05-29 |
| `FRED_US_10Y_Treasury_Yield.csv` | DGS10 | Daily ✅ | 2,194 | 2018-01-02 → 2026-05-29 |
| `FRED_US_2Y_Treasury_Yield.csv` | DGS2 | Daily ✅ | 2,194 | 2018-01-02 → 2026-05-29 |
| `FRED_WTI_Crude_Price.csv` | DCOILWTICO | Daily ✅ | 2,192 | 2018-01-02 → 2026-05-29 |

### A2. MOF Japan — Japanese Government Bond Yields (DAILY!)

| File | Source | Frequency | Obs | Date Range |
|------|--------|-----------|-----|------------|
| `MOF_Japan_2Y_10Y_JGB.csv` | MOF Japan (daily JGB fixing) | Daily ✅ | 2,031 | 2018-01-04 → 2026-04-30 |
| `MOF_Japan_Full_Yield_Curve.csv` | MOF Japan (full curve: 1Y–40Y) | Daily ✅ | 2,031 | 2018-01-04 → 2026-04-30 |

**Source:** Japan Ministry of Finance — [JGB Interest Rate Historical Data](https://www.mof.go.jp/english/policy/jgbs/reference/interest_rate/historical/jgbcme_all.csv)  
**Key advantage:** True daily JGB fixing data, not interpolated from monthly. Contains 1Y through 40Y maturities.

### A3. Yahoo Finance

| File | Ticker | Frequency | Obs | Date Range |
|------|--------|-----------|-----|------------|
| `YAHOO_SP500.csv` | ^GSPC | Daily ✅ | 2,113 | 2018-01-02 → 2026-05-29 |
| `YAHOO_Nikkei_225.csv` | ^N225 | Daily ✅ | 2,049 | 2018-01-04 → 2026-05-29 |
| `YAHOO_VIX_Index.csv` | ^VIX | Daily ✅ | 2,114 | 2018-01-02 → 2026-05-29 |
| `YAHOO_Brent_Crude_Futures.csv` | BZ=F | Daily ✅ | 2,116 | 2018-01-02 → 2026-05-29 |
| `YAHOO_USDJPY_X.csv` | USDJPY=X | Daily ✅ | 2,189 | 2018-01-02 → 2026-05-30 |
| `YAHOO_JPYUSD_X.csv` | JPYUSD=X | Daily ✅ | 2,189 | 2018-01-02 → 2026-05-30 |

### A4. Iacoviello GPR Index

| File | Source | Frequency | Obs | Date Range |
|------|--------|-----------|-----|------------|
| `GPR_Index_Daily.csv` | Iacoviello (Excel → CSV) | Calendar Daily ✅ | 3,068 | 2018-01-01 → 2026-05-26 |

---

## ⚠️ Section B: Monthly → Daily (Forward-Filled)

### Japan 3-Month CD Rate

| File | Original FRED ID | Original Freq | Method | Daily Obs |
|------|-----------------|---------------|--------|-----------|
| `Japan_3M_CD_Daily.csv` | IRSTCI01JPM156N | Monthly (100 obs) | Forward-fill (ffill) | 3,073 |

**Rationale:** Japanese short-term rates are only available at monthly frequency via FRED/OECD. Forward-filling from monthly is standard practice in VAR literature for slow-moving macro variables. The 3M CD rate typically changes only at BOJ policy meeting dates, so daily interpolation adds minimal spurious variation.

**Raw monthly file** retained as `FRED_Japan_3M_CD_Rate.csv`.

---

## ❓ Section C: Proxies & Alternatives

### C1. JPY/USD Bid-Ask Spread

**File:** `JPYUSD_Spread_Proxy.csv`  
**Method:** Intraday range proxy: `Spread = (High − Low) / Close × 100` from Yahoo USDJPY=X data  
**Obs:** 2,189, daily ✅  
**Mean spread:** 0.69 yen, typical range 0.3–2.0 yen  

**Literature support:** The (High−Low)/Close ratio is a standard proxy for effective bid-ask spread in microstructure literature (Corwin & Schultz, 2012; Goyenko, Holden & Trzcinka, 2009). It captures intraday liquidity costs when true bid-ask data is unavailable.

**If OANDA API becomes available:** Replace with true bid-ask data for robustness.

### C2. 1-Month JPY/USD 25-Delta Risk Reversal

**Status:** ❓ NOT YET PULLED  
**Issue:** BIS SDMX API does not expose options-implied risk reversal data. BIS publishes aggregate FX derivatives statistics (turnover, outstanding) but not daily market pricing data.

**Options (in priority order):**

| Option | Feasibility | Action Required |
|--------|-------------|-----------------|
| 1. BIS Statistics Explorer (Web UI) | Medium | Manual quarterly download → cubic spline interpolation to daily |
| 2. OANDA API options data | Medium-Low | Requires account; may have options chain data |
| 3. CME FX options | Low | Compute from listed JPY/USD option chains (complex) |
| 4. **Drop from VAR** | Immediate | VIX alone captures risk sentiment; many VAR studies use VIX as sole risk indicator |
| 5. Synthetic risk proxy | Immediate | Construct from VIX + Spread + EGAP first principal component |

---

## 📊 Variable Construction Reference

| Final Variable | Primary Source | Construction |
|---------------|----------------|--------------|
| ΔJPY/USD | `FRED_JPY_USD_ExchangeRate.csv` (DEXJPUS) | `100 × ln(s_t / s_{t−1})` |
| Δ(i−i\*) | `Japan_3M_CD_Daily.csv` + `FRED_US_3M_TBill_Rate.csv` | `Δ(JP_3M_CD − US_3M_TBill)` |
| ΔYCurve^Diff | `MOF_Japan_2Y_10Y_JGB.csv` + `FRED_US_10Y_Treasury_Yield.csv` + `FRED_US_2Y_Treasury_Yield.csv` | `Δ[(JGB10Y − JGB2Y) − (US10Y − US2Y)]` |
| ΔBrent | `FRED_WTI_Crude_Price.csv` (DCOILWTICO) | `100 × ln(WTI_t / WTI_{t−1})` |
| VIX | `YAHOO_VIX_Index.csv` | Level (Close), stationary |
| Spread | `JPYUSD_Spread_Proxy.csv` | `(High − Low)_USDJPY` (yen) |
| RiskReversal | ❓ TBD | BIS quarterly → daily spline, or dropped |
| EGAP | `YAHOO_SP500.csv` + `YAHOO_Nikkei_225.csv` | `100 × [r_SPX − r_NKY]` |
| GPR | `GPR_Index_Daily.csv` | `GPRD` column; for subsample classification only |

---

## 📁 Data Directory

```
data/raw/
├── FRED_JPY_USD_ExchangeRate.csv      ✅ DEXJPUS daily
├── FRED_US_3M_TBill_Rate.csv          ✅ DTB3 daily
├── FRED_US_10Y_Treasury_Yield.csv     ✅ DGS10 daily
├── FRED_US_2Y_Treasury_Yield.csv      ✅ DGS2 daily
├── FRED_WTI_Crude_Price.csv           ✅ DCOILWTICO daily
├── FRED_Japan_3M_CD_Rate.csv          ⚠️ IRSTCI01JPM156N monthly (raw)
├── FRED_Japan_10Y_JGB_Yield.csv       ⚠️ IRLTLT01JPM156N monthly (superseded)
├── Japan_3M_CD_Daily.csv              ⚠️ Forward-filled from monthly
├── MOF_Japan_2Y_10Y_JGB.csv           ✅ Japan 2Y & 10Y JGB DAILY
├── MOF_Japan_Full_Yield_Curve.csv     ✅ Full JGB curve (1Y–40Y) DAILY
├── YAHOO_SP500.csv                    ✅ ^GSPC daily
├── YAHOO_Nikkei_225.csv               ✅ ^N225 daily
├── YAHOO_VIX_Index.csv                ✅ ^VIX daily
├── YAHOO_Brent_Crude_Futures.csv      ✅ BZ=F daily
├── YAHOO_USDJPY_X.csv                 ✅ USD/JPY spot daily
├── YAHOO_JPYUSD_X.csv                 ✅ JPY/USD spot daily
├── JPYUSD_Spread_Proxy.csv            ⚠️ (High−Low) spread proxy
├── GPR_Index_Daily.csv                ✅ GPR calendar daily
└── DATA_COLLECTION_STATUS.md          📋 This file
```

---

## 🔧 Scripts

| Script | Status |
|--------|--------|
| `scripts/pull_fred_data.py` | Written — but use `pandas_datareader` approach instead |
| `scripts/pull_yahoo_data.py` | ✅ Executed successfully |
| `scripts/pull_gpr_data.py` | ✅ Executed (modified for daily Excel) |
| `scripts/pull_spread_data.py` | ✅ Executed (proxy computed) |
| `scripts/pull_bis_risk_reversal.py` | ❌ BIS API doesn't expose risk reversals |

---

## ⚡ Remaining Open Items

1. **Risk Reversal:** Only variable without daily data. Options: manual BIS download, API registration, or drop from VAR model.
2. **Data Alignment:** Merge all series on common trading days (NYSE ∩ TSE open). Nikkei 225 has Japanese holidays → fewer obs. GPR is calendar daily (include weekends) → align to trading calendar.
3. **ADF Tests:** Verify stationarity of all transformed series before VAR estimation.
