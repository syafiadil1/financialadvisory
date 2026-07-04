package gemini;

import util.ErrorUtil;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

public class GeminiService {

    private static final String API_URL_TEMPLATE = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s";
    private static final String DEFAULT_MODEL = "gemini-3.1-flash-lite";
    private static final int TIMEOUT_SECONDS = 30;

    private final HttpClient httpClient;

    public GeminiService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                .build();
    }

    public String generateAdvisory(String prompt) {
        String apiKey = getConfiguredValue("GEMINI_API_KEY", "gemini.api.key");

        if (apiKey == null || apiKey.trim().isEmpty()) {
            return "Gemini API key is not configured. Please set GEMINI_API_KEY as an environment variable or gemini.api.key as a JVM system property.";
        }

        String model = getConfiguredValue("GEMINI_MODEL", "gemini.model");
        if (model == null || model.trim().isEmpty()) {
            model = DEFAULT_MODEL;
        }

        try {
            String url = String.format(API_URL_TEMPLATE,
                    URLEncoder.encode(model.trim(), StandardCharsets.UTF_8),
                    URLEncoder.encode(apiKey.trim(), StandardCharsets.UTF_8));

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(buildRequestBody(prompt), StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                ErrorUtil.log("GeminiService.java", "generateAdvisory",
                        new Exception("Gemini returned HTTP " + response.statusCode() + ": " + response.body()));
                return "I could not reach Gemini successfully right now. Please check the API key, model, quota, and network connection.";
            }

            String text = extractFirstText(response.body());
            if (text == null || text.trim().isEmpty()) {
                return "Gemini returned an empty response. Please try again with a more specific financial question.";
            }
            
            System.out.println("Gemini response: " + text);

            return text.trim();
        } catch (Exception e) {
            ErrorUtil.log("GeminiService.java", "generateAdvisory", e);
            return "I could not generate an AI advisory response right now. Please try again later.";
        }
    }

    private String buildRequestBody(String prompt) {
        return """
                {
                  "contents": [
                    {
                      "role": "user",
                      "parts": [
                        {
                          "text": "%s"
                        }
                      ]
                    }
                  ],
                  "generationConfig": {
                    "maxOutputTokens": 256,
                    "thinkingConfig": {
                      "thinkingLevel": "MINIMAL"
					}
                  }
                }
                """.formatted(escapeJson(prompt));
    }

    private String extractFirstText(String json) {
        String key = "\"text\"";
        int keyIndex = json.indexOf(key);

        if (keyIndex < 0) {
            return null;
        }

        int colonIndex = json.indexOf(':', keyIndex + key.length());
        if (colonIndex < 0) {
            return null;
        }

        int startQuote = json.indexOf('"', colonIndex + 1);
        if (startQuote < 0) {
            return null;
        }

        StringBuilder builder = new StringBuilder();
        boolean escaping = false;

        for (int i = startQuote + 1; i < json.length(); i++) {
            char ch = json.charAt(i);

            if (escaping) {
                builder.append(unescapeJsonChar(ch, json, i));
                if (ch == 'u') {
                    i += 4;
                }
                escaping = false;
                continue;
            }

            if (ch == '\\') {
                escaping = true;
                continue;
            }

            if (ch == '"') {
                return builder.toString();
            }

            builder.append(ch);
        }

        return null;
    }

    private String unescapeJsonChar(char ch, String json, int index) {
        return switch (ch) {
            case '"' -> "\"";
            case '\\' -> "\\";
            case '/' -> "/";
            case 'b' -> "\b";
            case 'f' -> "\f";
            case 'n' -> "\n";
            case 'r' -> "\r";
            case 't' -> "\t";
            case 'u' -> {
                if (index + 4 < json.length()) {
                    String hex = json.substring(index + 1, index + 5);
                    try {
                        yield String.valueOf((char) Integer.parseInt(hex, 16));
                    } catch (NumberFormatException e) {
                        yield "";
                    }
                }
                yield "";
            }
            default -> String.valueOf(ch);
        };
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }

        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < value.length(); i++) {
            char ch = value.charAt(i);
            switch (ch) {
                case '"' -> builder.append("\\\"");
                case '\\' -> builder.append("\\\\");
                case '\b' -> builder.append("\\b");
                case '\f' -> builder.append("\\f");
                case '\n' -> builder.append("\\n");
                case '\r' -> builder.append("\\r");
                case '\t' -> builder.append("\\t");
                default -> {
                    if (ch < 0x20) {
                        builder.append(String.format("\\u%04x", (int) ch));
                    } else {
                        builder.append(ch);
                    }
                }
            }
        }
        return builder.toString();
    }

    private String getConfiguredValue(String environmentKey, String propertyKey) {
        String value = System.getenv(environmentKey);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(propertyKey);
        }
        return value;
    }
}
