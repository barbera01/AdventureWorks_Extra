function Create-RandomString {
    param (
        [int]$blocks = 1,
        [string]$delimiter = "-",
        [int]$maxLen = 10,
        [ValidateSet("Numeric","Alphanumeric","Alphabetic")]
        [string]$type = "Alphanumeric"
    )

    $random = New-Object System.Random
    $result = @()

    for ($i = 0; $i -lt $blocks; $i++) {
        $block = switch ($type) {
            "Numeric" {
                -join (1..$maxLen | ForEach-Object { $random.Next(0,10) })
            }
            "Alphabetic" {
                -join (1..$maxLen | ForEach-Object { [char]$random.Next(65,91) })
            }
            "Alphanumeric" {
                -join (1..$maxLen | ForEach-Object {
                    $charType = $random.Next(1,4)
                    if ($charType -le 2) { # Numeric
                        [char]$random.Next(48,58)
                    } elseif ($charType -eq 3) { # Uppercase Alphabet
                        [char]$random.Next(65,91)
                    } else { # Lowercase Alphabet
                        [char]$random.Next(97,123)
                    }
                })
            }
        }
        $result += $block
    }

    return ($result -join $delimiter)
}


# Define an array of manufacturer comments about bicycle parts
$manufacturerComments = @(
    "Our frame manufacturing exceeds industry standards for strength and durability.",
    "We have  implemented eco-friendly packaging solutions for all our bicycle parts.",
    "Our advanced logistics enable us to consistently beat delivery estimates, enhancing supply chain reliability.",
    "We ensure paint finishes on frames are consistent, though slight variances may occur due to our hand-finishing process.",
    "Assembly instructions are crafted by our engineers to ensure clarity and ease of setup for all bicycle models.",
    "Our customer support team is trained directly by the engineers to handle complex compatibility and installation inquiries.",
    "Extensive testing on chains and cassettes has shown minimal wear after prolonged use, thanks to our proprietary materials.",
    "Precision in tire manufacturing is achieved through rigorous quality control, ensuring each tire meets our exact specifications.",
    "Our high-performance gear systems are designed for optimal efficiency, though they require careful setup by experienced technicians.",
    "We offer competitive pricing on carbon fiber frames by optimizing our manufacturing processes for waste reduction.",
    "Continuous updates to product descriptions are made to ensure accuracy in weight and material specifications.",
    "Our electric bike batteries are developed to exceed standard usage times, incorporating the latest in battery technology.",
    "Handlebar materials are selected not only for durability but also for rider comfort over extended periods.",
    "We are expanding our color options in response to market demand and dealer feedback for next seasons models.",
    "We have a streamlined process for parts returns and exchanges, minimizing downtime for our dealers and customers.",
    "Innovation in bike rack design focuses on lightweight, sturdy construction for enhanced portability and strength.",
    "Saddle comfort is a key focus area, with ongoing research aimed at improving ergonomic design in our next-generation models.",
    "Our cycling computers are developed with a user-friendly interface, catering to both novice and advanced cyclists.",
    "Firmware for electronic shifting systems is regularly updated to enhance performance and shift accuracy.",
    "Frames and forks come with comprehensive warranty coverage, reflecting our confidence in their quality and durability.",
    "We provide maintenance kits designed to keep bicycles in peak condition, emphasizing the importance of regular upkeep.",
    "Sustainability is at the forefront of our material selection process, aiming to reduce environmental impact across our product lines.",
    "Feedback on handle grip wear has led to the development of new materials designed to extend grip life and improve comfort.",
    "We guarantee fast restocking times for essential parts, ensuring our dealers can meet customer needs without delay.",
    "Our customer service team receives ongoing training to provide unparalleled support and product knowledge.",
    "Efficiency in drivetrain components is achieved through innovative design, significantly reducing energy loss during cycling.",
    "Brake systems are tested under various conditions to ensure reliable all-weather performance.",
    "Feedback on seat post clamp mechanisms has prompted design improvements for easier adjustment and reliability.",
    "Our wheelsets are engineered to balance ride quality and durability, offering superior performance at a competitive price point.",
    "Design improvements in multi-tools focus on compatibility and ease of use, facilitating quicker adjustments during rides.",
    "We are committed to enhancing compatibility of bike computers across a wider range of models through ongoing software updates.",
    "Bike pump manuals are being revised for greater clarity on valve compatibility, ensuring ease of use for all cyclists.",
    "Our R&D team is focused on reducing bike frame weight without compromising on structural integrity or performance.",
    "Upcoming bike lines feature modern and sleek design elements, based on extensive market research and design innovation.",
    "Quality and performance standards for both indoor trainers and outdoor bikes are maintained through rigorous testing protocols.",
    "Dealer support services are designed to ensure comprehensive product knowledge and customer satisfaction.",
    "Safety and usability of quick-release systems are paramount, with continuous improvements based on user feedback.",
    "Aesthetic appeal of our latest bike models reflects positive dealer feedback and market trends.",
    "Quality control measures are stringent, ensuring all bikes and parts meet our high standards before shipment.",
    "Our manufacturing processes for electronic components are optimized for energy efficiency and sustainability.",
    "Development of bike diagnostic software focuses on enhancing user experience and providing valuable performance insights.",
    "Visibility features of reflective gear and lighting products are being enhanced to meet the highest safety standards.",
    "We are exploring additional gearing options to offer cyclists a wider range of performance choices.",
    "Easy-clean finishes on bike frames are developed to maintain aesthetics and durability, even under rigorous use.",
    "Anti-corrosion treatments for metal parts are a standard part of our manufacturing process, ensuring longevity.",
    "Reliability testing for bike locks and security accessories is conducted to provide peace of mind for cyclists.",
    "New accessory lines are in development to complement and enhance the functionality of our current bike models.",
    "The formulation of our energy products is refined based on extensive cyclist feedback, focusing on taste and nutritional value.",
    "Tailored bike gift packages are available, designed to meet the needs of cycling enthusiasts at all levels.",
    "Our commitment to quality and innovation has established us as a solid choice in the cycling industry."
)

# Function to get a random manufacturer comment
function Get-RandomManufacturerComment {
    return Get-Random -InputObject $manufacturerComments
}

$shippingComments = @(
    "Reinforced packaging for safe bike part arrival.",
    "Eco-friendly shipping partners chosen.",
    "Expedited options for urgent orders.",
    "Packaging sizes optimized to cut costs.",
    "Real-time tracking for all shipments.",
    "Global deliveries streamlined with customs.",
    "Efficiency and eco-focus in bulk shipments.",
    "Direct drop-shipping simplifies inventory.",
    "Special handling for sensitive components.",
    "Regular audits boost shipping reliability.",
    "Packaging is eco-friendly and recyclable.",
    "Weather-resistant packaging used.",
    "Regional hubs reduce times, carbon footprint.",
    "Logistics improved with shipping feedback.",
    "Assembly instructions included.",
    "Proactive communication on delays.",
    "Easy exchange and return process.",
    "Electronic parts shipped with care.",
    "Shipping insurance for high-value items.",
    "Delivery vehicles maintained for low emissions.",
    "Reusable packaging reduces waste.",
    "Clear labels with product info.",
    "Flexible shipping for dealer needs.",
    "Secure packaging with latest techniques.",
    "Seeking innovative shipping efficiencies.",
    "Shipping queries? Account managers help.",
    "Recyclable, biodegradable packaging materials.",
    "Seasonal shipping promotions for dealers.",
    "Pre-dispatch quality checks ensure standards.",
    "Compensation policy for delivery delays.",
    "Refined routes for faster, sustainable delivery.",
    "Comprehensive documentation provided.",
    "Efficient packaging for transport and storage.",
    "Partnerships with local shippers.",
    "Consolidated shipments minimize environmental impact."
)


function Get-ShippingComment {
    return Get-Random -InputObject $shippingComments
}
