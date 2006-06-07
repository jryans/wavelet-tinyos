/**
 * Retrieves wavelet configuration data 
 * @author Ryan Stinnett
 */
 
interface WaveletConfig {
  /**
   * Requests wavelet configuration data, such as our
   * neighbors and their coefficients.
   */
  command result_t getConfig();
  
  /**
   * Configuration reception has completed.
   * @param result Status of the reception
   * @param configData The requested data
   */
  event result_t configDone(WaveletLevel *configData, result_t result);
}
