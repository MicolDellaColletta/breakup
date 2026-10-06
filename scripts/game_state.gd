extends Node

var answered_phone: bool = false
var rules_broken: Array[String] = []

func break_rule(rule: String) -> void:
	if not rules_broken.has(rule):
		rules_broken.append(rule)

var evidence: Array[String] = []

func add_evidence(doc_id: String) -> void:
	if not evidence.has(doc_id):
		evidence.append(doc_id)
