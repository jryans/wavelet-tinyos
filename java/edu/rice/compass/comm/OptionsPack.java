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
   * Return the value (as a short) of the field 'data.data.wCntl.mask'
   */
  public short get_data_data_wCntl_mask();
	
	/**
   * Set the value of the field 'data.data.wCntl.mask'
   */
  public void set_data_data_wCntl_mask(short value);
  
  /**
   * Set the value of the field 'data.data.wCntl.cmd'
   */
  public void set_data_data_wCntl_cmd(short value);
  
  /**
   * Set the value of the field 'data.data.wCntl.sampleTime'
   */
  public void set_data_data_wCntl_data_opt_sampleTime(long value);
  
  /**
   * Set the value of the field 'data.data.wCntl.transformType'
   */
  public void set_data_data_wCntl_data_opt_transformType(short value);
  
  /**
   * Set the value of the field 'data.data.wCntl.resultType'
   */
  public void set_data_data_wCntl_data_opt_resultType(short value);
  
  /**
   * Set the value of the field 'data.data.wCntl.timeDomainLength'
   */
  public void set_data_data_wCntl_data_opt_timeDomainLength(short value);
  
  /**
   * Set the value of the field 'data.data.wCntl.data.comp.numBands'
   */
  public void set_data_data_wCntl_data_comp_numBands(short value);
  
  /**
   * Set the contents of the array 'data.data.wCntl.data.comp.compTarget' from the given float[]
   */
  public void set_data_data_wCntl_data_comp_compTarget(float[] value);

}