class Root {
  final List<Candidate> candidates;
  final UsageMetadata usageMetadata;
  final String modelVersion;

  Root({
    required this.candidates,
    required this.usageMetadata,
    required this.modelVersion,
  });

  factory Root.fromJson(Map<String, dynamic> json) {
    return Root(
      candidates: List<Candidate>.from(
        json["candidates"].map((x) => Candidate.fromJson(x)),
      ),
      usageMetadata: UsageMetadata.fromJson(json["usageMetadata"]),
      modelVersion: json["modelVersion"],
    );
  }
}

class Candidate {
  final Content content;

  Candidate({required this.content});

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      content: Content.fromJson(json["content"]),
    );
  }
}

class Content {
  final List<Part> parts;

  Content({required this.parts});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      parts: List<Part>.from(
        json["parts"].map((x) => Part.fromJson(x)),
      ),
    );
  }
}

class Part {
  final String text;

  Part({required this.text});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      text: json["text"],
    );
  }
}

class Text {
  final String response;
  final String title;

  Text({
    required this.response,
    required this.title,
  });
}

class UsageMetadata {
  final int promptTokenCount;
  final int candidatesTokenCount;
  final int totalTokenCount;

  UsageMetadata({
    required this.promptTokenCount,
    required this.candidatesTokenCount,
    required this.totalTokenCount,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) {
    return UsageMetadata(
      promptTokenCount: json["promptTokenCount"],
      candidatesTokenCount: json["candidatesTokenCount"],
      totalTokenCount: json["totalTokenCount"],
    );
  }
}