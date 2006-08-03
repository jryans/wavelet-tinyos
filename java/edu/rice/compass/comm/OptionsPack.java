package edu.rice.compass.comm;

public interface OptionsPack {

	/**
	 * Set the value of the field 'data.type'
	 */
	public abstract void set_data_type(short value);
	
	/**
	 * Return the value (as a short) of the field 'data.data.opt.mask'
	 */
	public abstract short get_data_data_opt_mask();

	/**
	 * Set the value of the field 'data.data.opt.mask'
	 */
	public abstract void set_data_data_opt_mask(short value);

	/**
	 * Return the value (as a int) of the field 'data.data.opt.pingNum'
	 */
	public abstract int get_data_data_opt_pingNum();

	/**
	 * Set the value of the field 'data.data.opt.pingNum'
	 */
	public abstract void set_data_data_opt_pingNum(int value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.txPower'
	 */
	public abstract short get_data_data_opt_txPower();

	/**
	 * Set the value of the field 'data.data.opt.txPower'
	 */
	public abstract void set_data_data_opt_txPower(short value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.rfAck'
	 */
	public abstract short get_data_data_opt_rfAck();

	/**
	 * Set the value of the field 'data.data.opt.rfAck'
	 */
	public abstract void set_data_data_opt_rfAck(short value);

	/**
	 * Return the value (as a int) of the field 'data.data.opt.radioOffTime'
	 */
	public abstract int get_data_data_opt_radioOffTime();

	/**
	 * Set the value of the field 'data.data.opt.radioOffTime'
	 */
	public abstract void set_data_data_opt_radioOffTime(int value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.hplPM'
	 */
	public abstract short get_data_data_opt_hplPM();

	/**
	 * Set the value of the field 'data.data.opt.hplPM'
	 */
	public abstract void set_data_data_opt_hplPM(short value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.rfChan'
	 */
	public abstract short get_data_data_opt_rfChan();

	/**
	 * Set the value of the field 'data.data.opt.rfChan'
	 */
	public abstract void set_data_data_opt_rfChan(short value);

	/**
	 * Return the value (as a short) of the field 'data.data.opt.radioRetries'
	 */
	public abstract short get_data_data_opt_radioRetries();

	/**
	 * Set the value of the field 'data.data.opt.radioRetries'
	 */
	public abstract void set_data_data_opt_radioRetries(short value);

}