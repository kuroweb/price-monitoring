const Page = ({ params }: { params: { slug: string[] } }) => {
  console.log(params.slug)
  return (
    <>
      <div>{params.slug.join(" / ")}</div>
      <div>slugと一致するカテゴリが存在しないときの表示を用意する</div>
      <div>slugと一致するカテゴリと紐づく商品を表示する</div>
    </>
  )
}

export default Page
