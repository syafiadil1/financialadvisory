package util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;

public class Encryption {
	
	private static final int ITERATIONS = 10000;
	private static final int KEY_LENGTH = 256;
	
	public static byte[] generateSalt() {
			SecureRandom random = new SecureRandom();
			byte[] salt = new byte[16];
			random.nextBytes(salt);
			return salt;
		}
	
	public static String hashPassword(String password, byte[] salt) throws Exception {
		PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
		SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA512");
		byte[] hash = skf.generateSecret(spec).getEncoded();
		return bytesToHex(hash);
	}

	public static boolean verifyPassword(String password, String storedHash, String salt) throws Exception {
		String hashOfInput = hashPassword(password, hexToBytes(salt));
		return hashOfInput.equals(storedHash);
	}

	public static String bytesToHex(byte[] bytes) {
		StringBuilder hexString = new StringBuilder();
		for (byte b : bytes) {
			String hex = Integer.toHexString(0xff & b);
			if (hex.length() == 1) hexString.append('0');
			hexString.append(hex);
		}
		return hexString.toString();
	}
	
	public static byte[] hexToBytes(String hex) {
		int len = hex.length();
		byte[] data = new byte[len / 2];
		for (int i = 0; i < len; i += 2) {
			data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
					+ Character.digit(hex.charAt(i + 1), 16));
		}
		return data;
	}
}
