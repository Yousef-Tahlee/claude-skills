# 🧰 دليل كل الـ skills

**110 skill**: منها 103 فيك تنزّلها، و7 مدمجين أصلاً بـ Claude.

## كيف بتنزّل skill؟

**1. على claude.ai أو تطبيق Claude (أسهل طريقة):**
كبس على رابط **⬇️ تحميل** جنب الـ skill، بينزل ملف zip.
بعدين افتح Claude ← **Settings ← Capabilities ← Skills ← Upload skill** وارفع الملف متل ما هو (لا تفكّه).

**2. على Claude Code (الأفضل للمبرمجين):** اكتب جوّا Claude Code:
```
/plugin marketplace add Yousef-Tahlee/claude-skills
```
وبعدين نزّل المجموعة يلي بدك ياها، مثلاً:
```
/plugin install engineering@claude-skills
```

**3. كلهم مرة وحدة:** [⬇️ all-skills.zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/all-skills.zip). فكّه وحط المجلدات بـ `~/.claude/skills/`.

---

## الفهرس

- **أسلوب البراند** (`brand-voice`): 3 skill
- **صناعة الـ plugins** (`cowork-plugin-management`): 2 skill
- **داتا وتحليل** (`data`): 10 skill
- **تصميم** (`design`): 7 skill
- **ملفات ومستندات** (`document-skills`): 6 skill
- **برمجة وهندسة** (`engineering`): 10 skill
- **skills متنوعة من Anthropic** (`example-skills`): 30 skill
- **تسويق** (`marketing`): 8 skill
- **الـ skills الشخصية** (`my-skills`): 19 skill
- **أدوات النظام** (`system-tools`): 4 skill
- **Zapier وأتمتة** (`zapier`): 4 skill
- **مدمجة بـ Claude**: 7 skill

## أسلوب البراند — `brand-voice`

على Claude Code: `/plugin install brand-voice@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 1 | **brand-voice-enforcement** | بتخلّي أي إيميل أو عرض أو بوست يطلع بنفس أسلوب ونَفَس البراند تبعك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/brand-voice--brand-voice-enforcement.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/brand-voice/skills/brand-voice-enforcement) |
| 2 | **discover-brand** | بتدوّر بـ Notion وDrive وConfluence وغيرهن على كل ملفات البراند المبعترة وبتعطيك تقرير شو لقت. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/brand-voice--discover-brand.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/brand-voice/skills/discover-brand) |
| 3 | **guideline-generation** | بتاخد ملفاتك أو تسجيلات مكالماتك وبتطلّعلك دليل رسمي لأسلوب البراند (نبرة، كلمات، أمثلة). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/brand-voice--guideline-generation.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/brand-voice/skills/guideline-generation) |

## صناعة الـ plugins — `cowork-plugin-management`

على Claude Code: `/plugin install cowork-plugin-management@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 4 | **cowork-plugin-customizer** | بتعدّل plugin جاهز ليناسب أدوات وشغل شركتك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/cowork-plugin-management--cowork-plugin-customizer.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/cowork-plugin-management/skills/cowork-plugin-customizer) |
| 5 | **create-cowork-plugin** | بتمشي معك خطوة خطوة لتعمل plugin جديد من الصفر. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/cowork-plugin-management--create-cowork-plugin.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/cowork-plugin-management/skills/create-cowork-plugin) |

## داتا وتحليل — `data`

على Claude Code: `/plugin install data@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 6 | **analyze** | بتجاوب على أي سؤال عن الداتا، من رقم واحد لتحليل كامل ليش صار هبوط أو طلوع. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--analyze.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/analyze) |
| 7 | **build-dashboard** | بتعملك داشبورد HTML تفاعلي فيه رسومات وفلاتر وجداول. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--build-dashboard.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/build-dashboard) |
| 8 | **create-viz** | بترسملك charts احترافية بالبايثون جاهزة للتقارير والعروض. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--create-viz.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/create-viz) |
| 9 | **data-context-extractor** | بتجمع معلومات شركتك عن الداتا (جداول، مصطلحات، مقاييس) وبتعمل منها skill خاصة فيكن. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--data-context-extractor.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/data-context-extractor) |
| 10 | **data-visualization** | بتعلّم Claude يختار نوع الرسم الصح ويرسمه بشكل مرتب وواضح. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--data-visualization.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/data-visualization) |
| 11 | **explore-data** | بتفحص أي جدول أو ملف جديد: شكله، القيم الناقصة، المكرر، والأشياء الغريبة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--explore-data.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/explore-data) |
| 12 | **sql-queries** | بتكتب SQL صحيح وسريع لكل أنواع قواعد البيانات (BigQuery، Snowflake، Postgres…). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--sql-queries.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/sql-queries) |
| 13 | **statistical-analysis** | بتعمل إحصاء: متوسطات، ترندات، قيم شاذة، واختبارات فرضيات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--statistical-analysis.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/statistical-analysis) |
| 14 | **validate-data** | بتراجع التحليل قبل ما تعرضه لتتأكد إنو الأرقام والاستنتاجات مظبوطة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--validate-data.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/validate-data) |
| 15 | **write-query** | بتحوّل سؤالك بالكلام العادي لـ query SQL جاهز ومحسّن. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/data--write-query.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/data/skills/write-query) |

## تصميم — `design`

على Claude Code: `/plugin install design@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 16 | **accessibility-review** | بتفحص التصميم أو الصفحة إذا مناسبة لذوي الاحتياجات (ألوان، كيبورد، قارئ شاشة). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/design--accessibility-review.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/design/skills/accessibility-review) |
| 17 | **design-critique** | بتعطيك رأي منظّم بالتصميم: سهولة الاستخدام، الترتيب، والتناسق. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/design--design-critique.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/design/skills/design-critique) |
| 18 | **design-handoff** | بتطلّع مواصفات كاملة للمطوّرين من التصميم (مقاسات، ألوان، حالات، شاشات). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/design--design-handoff.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/design/skills/design-handoff) |
| 19 | **design-system** | بتراجع وبتوثّق وبتوسّع الـ design system تبعك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/design--design-system.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/design/skills/design-system) |
| 20 | **research-synthesis** | بتلخّص مقابلات واستبيانات المستخدمين لأفكار ونتائج وتوصيات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/design--research-synthesis.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/design/skills/research-synthesis) |
| 21 | **user-research** | بتساعدك تخطط وتعمل بحث مستخدمين: أسئلة مقابلات، اختبارات، استبيانات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/design--user-research.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/design/skills/user-research) |
| 22 | **ux-copy** | بتكتبلك نصوص الواجهة: أزرار، رسائل خطأ، شاشات فاضية. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/design--ux-copy.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/design/skills/ux-copy) |

## ملفات ومستندات — `document-skills`

على Claude Code: `/plugin install document-skills@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 23 | **docx** | بتعمل وبتعدّل ملفات Word بشكل احترافي. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/document-skills--docx.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/document-skills/skills/docx) |
| 24 | **frontend-design** | بتخلّي واجهات المواقع والتطبيقات تطلع بتصميم مميز ومو تقليدي. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/document-skills--frontend-design.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/document-skills/skills/frontend-design) |
| 25 | **pdf** | كل شي عن الـ PDF: قراءة، دمج، تقسيم، تعبئة فورمات، وإنشاء. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/document-skills--pdf.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/document-skills/skills/pdf) |
| 26 | **pptx** | بتعمل وبتعدّل عروض PowerPoint. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/document-skills--pptx.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/document-skills/skills/pptx) |
| 27 | **product-self-knowledge** | بتخلّي Claude يعطي معلومات صحيحة ومحدّثة عن منتجات Anthropic. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/document-skills--product-self-knowledge.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/document-skills/skills/product-self-knowledge) |
| 28 | **xlsx** | بتعمل وبتعدّل ملفات Excel مع معادلات وتنسيق. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/document-skills--xlsx.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/document-skills/skills/xlsx) |

## برمجة وهندسة — `engineering`

على Claude Code: `/plugin install engineering@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 29 | **architecture** | بتساعدك تختار بين تقنيات وتوثّق القرار المعماري مع الإيجابيات والسلبيات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--architecture.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/architecture) |
| 30 | **code-review** | بتراجع الكود من ناحية الأمان والأداء والأخطاء قبل الـ merge. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--code-review.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/code-review) |
| 31 | **debug** | جلسة تصليح أخطاء منظّمة: نكرر المشكلة، نعزلها، نلاقي السبب، ونصلّحها. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--debug.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/debug) |
| 32 | **deploy-checklist** | قائمة فحص قبل ما تنزّل أي إصدار على الـ production. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--deploy-checklist.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/deploy-checklist) |
| 33 | **documentation** | بتكتب توثيق تقني: README، runbook، API docs، دليل للموظف الجديد. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--documentation.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/documentation) |
| 34 | **incident-response** | بتمشي معك لما يوقع السيرفر: تقييم، تواصل، وتقرير بعد ما تنحل المشكلة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--incident-response.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/incident-response) |
| 35 | **standup** | بتجهّزلك تحديث الـ standup اليومي من شغلك الأخير. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--standup.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/standup) |
| 36 | **system-design** | بتصمّم أنظمة وخدمات وAPIs وقواعد بيانات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--system-design.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/system-design) |
| 37 | **tech-debt** | بتلاقي الديون التقنية بالكود وبترتّب شو لازم ينصلح أول. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--tech-debt.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/tech-debt) |
| 38 | **testing-strategy** | بتخطط شو الاختبارات يلي لازم تنكتب وكيف. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/engineering--testing-strategy.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/engineering/skills/testing-strategy) |

## skills متنوعة من Anthropic — `example-skills`

على Claude Code: `/plugin install example-skills@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 39 | **algorithmic-art** | بترسم فن بالكود (p5.js) مع عشوائية وتحكم تفاعلي. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--algorithmic-art.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/algorithmic-art) |
| 40 | **benepass-reimbursement** | بتقدّم طلبات استرداد المصاريف على منصة Benepass. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--benepass-reimbursement.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/benepass-reimbursement) |
| 41 | **brand-guidelines** | بتطبّق ألوان وخطوط Anthropic الرسمية على أي شي بتعمله. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--brand-guidelines.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/brand-guidelines) |
| 42 | **call-to-book** | بتعمل مكالمة هاتف لتحجز موعد أو طاولة، بعد ما تشوف تقويمك وتاخد موافقتك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--call-to-book.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/call-to-book) |
| 43 | **cancel-unsubscribe** | بتلغيلك أي اشتراك، ولو من صورة فاتورة، وبتراجع كل اشتراكاتك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--cancel-unsubscribe.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/cancel-unsubscribe) |
| 44 | **canvas-design** | بتعمل بوسترات وتصاميم فنية كصور PNG أو PDF. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--canvas-design.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/canvas-design) |
| 45 | **deep-research** | بحث معمّق من مصادر كتيرة وبيطلّعلك تقرير كامل. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--deep-research.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/deep-research) |
| 46 | **doc-coauthoring** | بتكتب معك مستندات ومقترحات خطوة بخطوة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--doc-coauthoring.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/doc-coauthoring) |
| 47 | **docs** | بتعمل مستندات قابلة للتعديل والمشاركة والتعليق جوّا Claude. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--docs.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/docs) |
| 48 | **event-planning** | بتخطط أي مناسبة، من عشا عيد ميلاد لعرس: مكان، ضيوف، جدول. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--event-planning.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/event-planning) |
| 49 | **file-expenses** | بتقدّم مصاريف واسترداد على أي منصة (Expensify، Brex، Concur…). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--file-expenses.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/file-expenses) |
| 50 | **file-form** | بتساعدك بالمعاملات الرسمية: فورمات، مخالفات، تجديد جواز. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--file-form.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/file-form) |
| 51 | **financial-calculator** | حسابات مالية: ضرايب، قروض، تقاعد، إيجار ولا شرا. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--financial-calculator.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/financial-calculator) |
| 52 | **google-workspace** | بتعرف تتعامل صح مع ملفات Google Drive وDocs وSheets وSlides. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--google-workspace.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/google-workspace) |
| 53 | **grocery-shopping** | بتساعدك تطلب أغراض البيت أونلاين ضمن ميزانيتك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--grocery-shopping.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/grocery-shopping) |
| 54 | **hire-help** | بتلاقيلك حدا يساعدك: تنضيف، تصليح، نقل عفش. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--hire-help.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/hire-help) |
| 55 | **import-memory** | بتنقل ذاكرتك من مساعد AI تاني (متل ChatGPT) لـ Claude. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--import-memory.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/import-memory) |
| 56 | **internal-comms** | بتكتب رسائل وتحديثات داخلية للشركة بالشكل المعتمد عندكن. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--internal-comms.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/internal-comms) |
| 57 | **learn** | بتشرحلك أي موضوع لتفهمه فعلاً، مو بس تاخد الجواب. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--learn.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/learn) |
| 58 | **mcp-builder** | دليل لتبني MCP server يوصل Claude بأي خدمة خارجية. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--mcp-builder.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/mcp-builder) |
| 59 | **meal-delivery** | بتطلبلك أكل يوصل بالوقت يلي بدك ياه بالضبط. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--meal-delivery.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/meal-delivery) |
| 60 | **morning** | بتعملك ملخص صباحي يومي (إيميلات، مواعيد، مهام) بصفحة مرتبة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--morning.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/morning) |
| 61 | **paint** | بترسم صور بأسلوب الألوان المائية بالكود. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--paint.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/paint) |
| 62 | **prescription-refill** | بتساعدك تجدد وصفة دوا من الصيدلية. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--prescription-refill.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/prescription-refill) |
| 63 | **return-refund** | بتساعدك ترجّع غرض أو تسترد مصاريك من أي متجر. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--return-refund.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/return-refund) |
| 64 | **setup-writing-style** | بتتعلم أسلوب كتابتك من رسائلك ليصير Claude يكتب متلك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--setup-writing-style.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/setup-writing-style) |
| 65 | **skill-creator** | بتعمل skills جديدة، وبتحسّن الموجودة، وبتقيس أداءها. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--skill-creator.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/skill-creator) |
| 66 | **slack-gif-creator** | بتعمل صور GIF متحركة مناسبة للسلاك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--slack-gif-creator.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/slack-gif-creator) |
| 67 | **theme-factory** | بتعطي أي عرض أو صفحة ثيم جاهز من 10 ثيمات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--theme-factory.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/theme-factory) |
| 68 | **web-artifacts-builder** | بتبني صفحات ويب كبيرة بـ React وTailwind جوّا Claude. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/example-skills--web-artifacts-builder.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/example-skills/skills/web-artifacts-builder) |

## تسويق — `marketing`

على Claude Code: `/plugin install marketing@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 69 | **brand-review** | بتراجع المحتوى إذا ماشي مع أسلوب البراند وبتقترح تصليحات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--brand-review.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/brand-review) |
| 70 | **campaign-plan** | بتعمل خطة حملة تسويقية كاملة مع تقويم محتوى ومقاييس نجاح. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--campaign-plan.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/campaign-plan) |
| 71 | **competitive-brief** | بتدرس المنافسين وبتطلّعلك وين الفرص والتهديدات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--competitive-brief.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/competitive-brief) |
| 72 | **content-creation** | بتكتب محتوى تسويقي: مقالات، بوستات، إيميلات، صفحات هبوط. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--content-creation.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/content-creation) |
| 73 | **draft-content** | بتكتب مسودات محتوى مع عناوين واقتراحات SEO لكل منصة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--draft-content.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/draft-content) |
| 74 | **email-sequence** | بتصمم سلسلة إيميلات كاملة (ترحيب، متابعة، إرجاع عملاء). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--email-sequence.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/email-sequence) |
| 75 | **performance-report** | بتعمل تقرير أداء تسويقي: شو نجح، شو فشل، وشو الخطوة الجاية. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--performance-report.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/performance-report) |
| 76 | **seo-audit** | بتفحص الموقع من ناحية SEO وبتعطيك خطة تحسين. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/marketing--seo-audit.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/marketing/skills/seo-audit) |

## الـ skills الشخصية — `my-skills`

على Claude Code: `/plugin install my-skills@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 77 | **code-review-skill** | دليل مراجعة كود شامل لكل اللغات والفريموركات (React، Python، Go…). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--code-review-skill.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/code-review-skill) |
| 78 | **debug** | بتصلّح أخطاء الواجهات بأدلة حقيقية من المتصفح بدل console.log. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--debug.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/debug) |
| 79 | **deep-research** | بحث معمّق من مصادر كتيرة وبيطلّعلك تقرير كامل. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--deep-research.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/deep-research) |
| 80 | **docs** | بتعمل مستندات قابلة للتعديل والمشاركة والتعليق جوّا Claude. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--docs.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/docs) |
| 81 | **docx** | بتعمل وبتعدّل ملفات Word بشكل احترافي. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--docx.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/docx) |
| 82 | **generating-end-to-end-tests** | بتكتب اختبارات E2E للمواقع (Playwright، Cypress، Selenium). | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--generating-end-to-end-tests.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/generating-end-to-end-tests) |
| 83 | **grill-me** | بتسألك أسئلة ورا بعض عن خطتك لحتى تتأكد إنها مدروسة من كل النواحي. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--grill-me.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/grill-me) |
| 84 | **import-memory** | بتنقل ذاكرتك من مساعد AI تاني (متل ChatGPT) لـ Claude. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--import-memory.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/import-memory) |
| 85 | **mobile-first-design** | بتصمم المواقع للموبايل أول وبعدين للشاشات الكبيرة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--mobile-first-design.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/mobile-first-design) |
| 86 | **morning** | بتعملك ملخص صباحي يومي (إيميلات، مواعيد، مهام) بصفحة مرتبة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--morning.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/morning) |
| 87 | **pdf** | كل شي عن الـ PDF: قراءة، دمج، تقسيم، تعبئة فورمات، وإنشاء. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--pdf.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/pdf) |
| 88 | **pptx** | بتعمل وبتعدّل عروض PowerPoint. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--pptx.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/pptx) |
| 89 | **security-review** | بتفحص الكود متل باحث أمني لتلاقي الثغرات. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--security-review.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/security-review) |
| 90 | **startup-hook-skill** | بتعمل hook بيشتغل أول ما تفتح session بـ Claude Code. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--session-start-hook.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/session-start-hook) |
| 91 | **setup-writing-style** | بتتعلم أسلوب كتابتك من رسائلك ليصير Claude يكتب متلك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--setup-writing-style.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/setup-writing-style) |
| 92 | **skill-creator** | بتعمل skills جديدة، وبتحسّن الموجودة، وبتقيس أداءها. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--skill-creator.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/skill-creator) |
| 93 | **stop-slop** | بتشيل من النص الكلام يلي باين إنو مكتوب بالـ AI. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--stop-slop.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/stop-slop) |
| 94 | **tdd-guide** | دليل للبرمجة بطريقة TDD: الاختبار أول وبعدين الكود. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--tdd-guide.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/tdd-guide) |
| 95 | **xlsx** | بتعمل وبتعدّل ملفات Excel مع معادلات وتنسيق. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/my-skills--xlsx.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/my-skills/skills/xlsx) |

## أدوات النظام — `system-tools`

على Claude Code: `/plugin install system-tools@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 96 | **computer-use-desktop** | بتخلّي Claude يستخدم شاشة كمبيوتر لينكس: يفتح برامج ويكبس ويكتب. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/system-tools--computer-use-desktop.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/system-tools/skills/computer-use-desktop) |
| 97 | **playwright-cli** | بتتحكم بالمتصفح أوتوماتيك وبتختبر صفحات الويب. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/system-tools--playwright-cli.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/system-tools/skills/playwright-cli) |
| 98 | **playwright-component-testing** | بتجهّز اختبار مكوّنات الواجهة بـ Playwright. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/system-tools--playwright-component-testing.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/system-tools/skills/playwright-component-testing) |
| 99 | **playwright-trace** | بتفتح ملفات trace تبع Playwright لتعرف شو صار بالاختبار. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/system-tools--playwright-trace.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/system-tools/skills/playwright-trace) |

## Zapier وأتمتة — `zapier`

على Claude Code: `/plugin install zapier@claude-skills`

| # | الـ skill | شو بتعمل | تحميل | الملفات |
|---|---|---|---|---|
| 100 | **zapier-demo** | أول تجربة مع Zapier: بتشغّلك أول action بأبسط طريقة. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/zapier--zapier-demo.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/zapier/skills/zapier-demo) |
| 101 | **zapier-explore** | بتقترحلك شو فيك تعمل بـ Zapier حسب شغلك والتطبيقات يلي بتستعملها. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/zapier--zapier-explore.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/zapier/skills/zapier-explore) |
| 102 | **zapier-onboard** | بتعرّفك على Zapier MCP وبتربطلك حسابك. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/zapier--zapier-onboard.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/zapier/skills/zapier-onboard) |
| 103 | **zapier-status** | بتفحص إعدادات Zapier: شو شغّال، شو مكرر، وشو خربان. | [⬇️ zip](https://github.com/Yousef-Tahlee/claude-skills/raw/main/downloads/zapier--zapier-status.zip) | [📂 فتح](https://github.com/Yousef-Tahlee/claude-skills/tree/main/plugins/zapier/skills/zapier-status) |

## مدمجة بـ Claude — ما بدها تنزيل

هدول موجودين أصلاً عند أي حدا عنده Claude. رخصتهن ما بتسمح ينسخوا برّا Claude، لهيك ما في رابط تحميل.

| # | الـ skill | شو بتعمل |
|---|---|---|
| 104 | **artifact-emulator** | بتخلّي Claude يشوف الصفحة أو العرض يلي عمله متل ما رح تشوفه إنت. |
| 105 | **built-in-browser** | بتعلّم Claude يستخدم المتصفح المدمج بتطبيق الديسكتوب. |
| 106 | **chrome-browser** | بتعلّم Claude يستخدم إضافة Claude in Chrome بمتصفحك. |
| 107 | **computer-use** | بتخلّي Claude يتحكم ببرامج كمبيوترك (يكبس، يكتب، ياخد سكرين شوت). |
| 108 | **file-reading** | بتعلّم Claude يقرأ الملفات يلي بترفعها بالطريقة الصح. |
| 109 | **pdf-reading** | بتعلّم Claude يقرأ ملفات PDF ويطلّع منها نصوص وجداول. |
| 110 | **video-making** | بتساعد Claude يعمل فيديوهات جديدة. |

---

المجموع: **110 skill**. هاد الملف بيتحدّث لحاله مع كل sync.
