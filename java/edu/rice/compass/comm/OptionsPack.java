package edu.rice.compass.comm;

public interface OptionsPack {

	/**
	 * Set the value of the field 'data.type'
	 */
	public void set_data_type(short value);
	
	/**
	 * Return the value (as a short) of the field 'data.data.opt.mask'
	 */
	public short get_data_data_opt_mask();

	/**
	 * Set the value of the field 'data.data.opt.mask'
	 */
	public void set_data_data_opt_mask(short value);

	/**
	 * Return the value (as a int) of the field 'data.data.opt.pingNum'
	 */
	public int get_data_data_opt_pingNum();

	/**
	 * Set the value of the field 'data.data.opt.pingNum'
	 */
	public void set_data_data_opt_pingNum(int value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.txPower'
	 */
	public short get_data_data_opt_txPower();

	/**
	 * Set the value of the field 'data.data.opt.txPower'
	 */
	public void set_data_data_opt_txPower(short value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.rfAck'
	 */
	public short get_data_data_opt_rfAck();

	/**
	 * Set the value of the field 'data.data.opt.rfAck'
	 */
	public void set_data_data_opt_rfAck(short value);

	/**
	 * Return the value (as a int) of the field 'data.data.opt.radioOffTime'
	 */
	public int get_data_data_opt_radioOffTime();

	/**
	 * Set the value of the field 'data.data.opt.radioOffTime'
	 */
	public void set_data_data_opt_radioOffTime(int value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.hplPM'
	 */
	public short get_data_data_opt_hplPM();

	/**
	 * Set the value of the field 'data.data.opt.hplPM'
	 */
	public void set_data_data_opt_hplPM(short value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.rfChan'
	 */
	public short get_data_data_opt_rfChan();

	/**
	 * Set the value of the field 'data.data.opt.rfChan'
	 */
	public void set_data_data_opt_rfChan(short value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.radioRetries'
	 */
	public short get_data_data_opt_radioRetries();

	/**
	 * Set the value of the field 'data.data.opt.radioRetries'
	 */
	public void set_data_data_opt_radioRetries(short value);
	
	/**
   * Return the value (as a short) of the field 'data.data.wState.mask'
   */
  public short get_data_data_wState_mask();
	
	/**
   * Set the value of the field 'data.data.wState.mask'
   */
  public void set_data_data_wState_mask(short value);
  
  /**
   * Set the value of the field 'data.data.wState.state'
   */
  public void set_data_data_wState_state(short value);
  
  /**
   * Set the value of the field 'data.data.wState.dataSetTime'
   */
  public void set_data_data_wState_dataSetTime(long value);
  
  /**
   * Set the value of the field 'data.data.wState.transformType'
   */
  public void set_data_data_wState_transformType(short value);
  
  /**
   * Set the value of the field 'data.data.wState.resultType'
   */
  public void set_data_data_wState_resultType(short value);
  
  /**
   * Set the value of the field 'data.data.wState.timeDomainLength'
   */
  public void set_data_data_wState_timeDomainLength(short value);

}