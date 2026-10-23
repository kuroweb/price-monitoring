// @vitest-environment node
import { ESLint } from 'eslint'
import { describe, expect, it } from 'vitest'

const eslint = new ESLint()
const filePath = 'components/LintExample.tsx'

describe('ESLint 設定', () => {
  it('import の順序違反を例外にせず報告し、自動修正する', async () => {
    const code = "import z from 'zod'\nimport fs from 'node:fs'\nexport { z, fs }\n"
    const [result] = await eslint.lintText(code, { filePath })

    expect(result.messages.filter(({ ruleId }) => ruleId === 'import-x/order')).toHaveLength(2)

    const [fixed] = await new ESLint({ fix: true }).lintText(code, { filePath })
    expect(fixed.errorCount).toBe(0)
    expect(fixed.output).toBe("import fs from 'node:fs'\n\nimport z from 'zod'\nexport { z, fs }\n")
  })

  it.each([
    {
      rule: 'jsx-a11y-x/alt-text',
      code: 'export default function Example() { return <img src="/image.png" /> }',
    },
    {
      rule: 'jsx-a11y-x/alt-text',
      code: 'import Image from \'next/image\'\nexport default function Example() { return <Image src="/image.png" width={20} height={20} /> }',
    },
    {
      rule: 'jsx-a11y-x/aria-props',
      code: 'export default function Example() { return <div aria-bogus="true" /> }',
    },
    {
      rule: 'jsx-a11y-x/aria-proptypes',
      code: 'export default function Example() { return <div aria-hidden="invalid" /> }',
    },
    {
      rule: 'jsx-a11y-x/aria-unsupported-elements',
      code: 'export default function Example() { return <meta aria-label="example" /> }',
    },
    {
      rule: 'jsx-a11y-x/role-has-required-aria-props',
      code: 'export default function Example() { return <div role="checkbox" /> }',
    },
    {
      rule: 'jsx-a11y-x/role-supports-aria-props',
      code: 'export default function Example() { return <div role="button" aria-checked="true" /> }',
    },
  ])('$rule のアクセシビリティ違反をエラーにする', async ({ code, rule }) => {
    const [result] = await eslint.lintText(code, { filePath })

    expect(result.messages).toEqual(
      expect.arrayContaining([expect.objectContaining({ ruleId: rule, severity: 2 })]),
    )
  })

  it.each([
    {
      rule: '@eslint-react/no-missing-key',
      code: 'export default function Example() { return [1, 2].map(value => <div>{value}</div>) }',
    },
    {
      rule: '@eslint-react/rules-of-hooks',
      code: "import { useState } from 'react'\nexport default function Example({ enabled }: { enabled: boolean }) { if (enabled) { useState(0) } return null }",
    },
    {
      rule: '@next/next/no-sync-scripts',
      code: 'export default function Example() { return <script src="/script.js" /> }',
    },
    {
      rule: '@typescript-eslint/no-unused-vars',
      code: 'const unused = 1\nexport default function Example() { return null }',
    },
  ])('$rule の違反をエラーにする', async ({ code, rule }) => {
    const [result] = await eslint.lintText(code, { filePath })

    expect(result.messages).toEqual(
      expect.arrayContaining([expect.objectContaining({ ruleId: rule, severity: 2 })]),
    )
  })

  it('不要な JSX の波括弧と空のコンポーネントの閉じタグを自動修正する', async () => {
    const code =
      'function Child({ title }: { title: string }) { return <div>{title}</div> }\nexport default function Example() { return <Child title={"sample"}></Child> }'
    const [result] = await eslint.lintText(code, { filePath })

    expect(result.messages.map(({ ruleId }) => ruleId)).toEqual(
      expect.arrayContaining([
        '@stylistic/jsx-curly-brace-presence',
        '@stylistic/jsx-self-closing-comp',
      ]),
    )

    const [fixed] = await new ESLint({ fix: true }).lintText(code, { filePath })
    expect(fixed.output).toBe(
      'function Child({ title }: { title: string }) { return <div>{title}</div> }\nexport default function Example() { return <Child title="sample" /> }',
    )
    expect(fixed.errorCount).toBe(0)
  })

  it('JSX 内だけで使うコンポーネントと空の HTML 要素を許可する', async () => {
    const code =
      'function Child() { return <div></div> }\nexport default function Example() { return <><Child /><p>don&apos;t &quot;quote&quot; &gt; &rbrace;</p></> }'
    const [result] = await eslint.lintText(code, { filePath })

    expect(result.messages).toEqual([])
  })

  it('JavaScript の JSX でも未定義コンポーネントを検出する', async () => {
    const [result] = await eslint.lintText(
      'export default function Example() { return <Missing /> }',
      { filePath: 'components/LintExample.jsx' },
    )

    expect(result.messages).toEqual(
      expect.arrayContaining([expect.objectContaining({ ruleId: 'no-undef', severity: 2 })]),
    )
  })
})
