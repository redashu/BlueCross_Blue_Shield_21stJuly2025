variable "ashu_num" {
    type = list(number) 
    default = [ 1,2,3,4 ]
  
}

resource "null_resource" "example_count" {
    count = length(var.ashu_num) # count range is 4 
    provisioner "local-exec" {
        command = "echo my loop is : ${var.ashu_num[count.index]}"
      
    }
  
}

output "my_output" {
    value = [for i in var.ashu_num : "Counting:  ${i}"]
  
}
