package adInterfaceReader;
/**
 * This class reads from and writes to the analog/digital converter
 * 
 * @author <A HREF="mailto:TSNouidui@lbl.gov">Thierry Nouidui</A>.
 * @version 1.0, October 22, 2010
 */
public class ADInterface {
	/**
	 * This method read data from the Analog/Digital converter.
	 * 
	 * @param boardNum
	 *            board number of the analog digital converter.
	 * @param chan
	 *            channel number.
	 * @param gain
	 *            channel gain.
	 * @param dataValue
	 *            data value.
	 * @param options
	 *            Options.
	 * @return read data value.
	 */
	public native float cbVIn(int boardNum, int chan, int gain,
			float dataValue, int options);

	/**
	 * This method writes data in the Analog/Digital converter.
	 * 
	 * @param boardNum
	 *            board number of the analog digital converter.
	 * @param chan
	 *            channel number.
	 * @param gain
	 *            channel gain.
	 * @param dataValue
	 *            data value.
	 * @param options
	 *            Options
	 * @return the written data value.
	 */
	public native float cbVOut(int boardNum, int chan, int gain,
			float dataValue, int options);

	static {
		// load the dll with the C-function
		System.loadLibrary("ADInterfaceMCC");
	}
}
