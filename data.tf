# Este bloque se utiliza para definir un documento de política de IAM 
#que no se va a crear ni modificar, sino que se utilizará como datos en otros recursos.
data "aws_iam_policy_document" "s3_policy" {
  statement {
    #se especifica el tipo de entidad principal a la que se aplicará la política. 
    #En este caso, el tipo es "AWS" y se proporciona el ARN (Amazon Resource Name) del usuario "laura.perlaza"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::017333715993:user/laura.perlaza"]
    }
    # actions contiene una lista de acciones (permisos) que se permitirán en la política. 
    #En este caso, se permiten las acciones "s3:GetObject" y "s3:ListBucket".
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    #El atributo resources define los recursos a los que se aplicarán las acciones permitidas.
    #Aquí se utiliza el comodín ("*"), lo que indica que las acciones se aplicarán a cualquier recurso de S3.
    resources = [
      "*"
    ]
  }
}