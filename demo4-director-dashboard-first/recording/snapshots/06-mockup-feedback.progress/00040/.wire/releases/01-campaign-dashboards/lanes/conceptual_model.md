# Lane: conceptual_model

Release: 01-campaign-dashboards
Task: /wire:conceptual_model-generate 01-campaign-dashboards (validate runs automatically)
Owns: .wire/releases/01-campaign-dashboards/design/conceptual_model.md, .wire/releases/01-campaign-dashboards/lanes/conceptual_model.md
Dispatched: 2026-10-05 20:10 by orchestrator [910893ca]

## Items
- [x] generate conceptual model
- [x] validate conceptual model

## Results

### Generate
Result: complete.
File written: .wire/releases/01-campaign-dashboards/design/conceptual_model.md
Entities: 5 (Campaign, CampaignPerformance, Article, PageEngagement, Date).
Relationships: 4 in the ERD, plus a stated scope boundary (no join key between Campaign and Article in Phase 1).
Open questions: 1 (OQ-1, article-vs-page grain, deferred to mockup review per R-7).
Ran inline, not delegated: this lane is the data-designer, and the flat rule plus the delegate skip condition both forbid spawning a sub-agent.

### Validate (auto-validate, ran as part of generate)
Result: PASS. 12 of 12 checks passed, 0 failed.

| Check | Status |
|-------|--------|
| Entity coverage | pass |
| Cardinality completeness | pass |
| Relationship labels | pass |
| No column leakage | pass |
| Mermaid syntax validity | pass |
| PascalCase naming | pass |
| Entity descriptions | pass |
| Reference legibility | pass |
| Relationship narrative | pass |
| Open questions documented | pass |
| Out-of-scope section present | pass |
| Volume estimates | pass |

modality_coverage: skipped (status.md has no model_source: modality). Not reported as pass.

### status.md values to record (lane does not write status.md; orchestrator applies these)
conceptual_model:
  generate: complete
  validate: pass
  review: not_started
  file: design/conceptual_model.md
  generated_date: 2026-10-05
  validated_date: 2026-10-05
current_phase: design (already set)

### execution_log.md rows to record (lane does not write the log; orchestrator applies these)
| 2026-10-05 20:1x | /wire:conceptual_model-generate | complete | Generated entity model, 5 entities, 4 relationships | Mark Rittman | conceptual_model lane | n/a | n/a | n/a |
| 2026-10-05 20:1x | /wire:conceptual_model-validate | pass | 12 checks passed, 0 failed | Mark Rittman | conceptual_model lane | n/a | n/a | n/a |

### Needs ruling
None. No data model registry vertical proposal was offered (no registry configured). business_rules advisory dependency waived per R-3, noted in the model's scope note.

state: complete — conceptual model generated (5 entities, 4 relationships, 1 open question) and auto-validated PASS 12/12.
